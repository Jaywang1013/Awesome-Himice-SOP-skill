#!/usr/bin/env ruby
# privacy-scan.rb — 内容级隐私扫描
#
# 只扫被 git 跟踪的文件（stdin 接收 `git ls-files -z` 的路径），命中高置信隐私模式即：
#   - 文件属于「已批准公开基线」且 SHA-256 与清单一致  → 整文件豁免（打印 EXEMPT）
#   - 文件在 skills/ 或 integrations/ 下（可分发面）  → 永不豁免，命中即 FAIL
#   - 其余命中（含路径不在基线清单、或校验和不符）    → FAIL
#
# 用法（由 validate.sh --privacy 调用）:
#   git ls-files -z | ruby scripts/privacy-scan.rb <repo_root>

require 'set'
require 'digest'

repo = ARGV.fetch(0)

# ---- 白名单：只给「说明性命中」（文档里提到 /Users/Zhuanz 这类），不给真实 PII。
allow_path = File.join(repo, 'scripts', 'privacy-allowlist.txt')
# 白名单两类：
#   1) `路径:行号`  —— 精确放行某一行（行号会漂移，慎用）
#   2) 行内特征片段 —— 命中行**包含**该片段才放行（推荐，抗行号漂移；须足够特异）
line_keys = Set.new
frag_rules = []
if File.exist?(allow_path)
  File.readlines(allow_path, encoding: 'UTF-8').each do |l|
    l = l.strip
    next if l.empty? || l.start_with?('#')
    if l.match?(/\A.+:\d+\z/)
      line_keys << l
    else
      frag_rules << l
    end
  end
end

# ---- 已批准公开基线：路径 => sha256（有条件豁免）
baselines = {}
baseline_path = File.join(repo, 'scripts', 'approved-baselines.txt')
if File.exist?(baseline_path)
  File.readlines(baseline_path, encoding: 'UTF-8').each do |l|
    l = l.strip
    next if l.empty? || l.start_with?('#')
    parts = l.split(/\s+/)
    next if parts.length < 2
    sha = parts.pop.downcase
    path = parts.join(' ')
    baselines[path] = sha
  end
end

# 可分发面：永不豁免（即使被写进 approved-baselines.txt 也不认）
NEVER_EXEMPT_PREFIXES = ['skills/', 'integrations/'].freeze

# 规则自指文件：它们存在的意义就是「写出这些模式」或「登记豁免」，扫自己没有意义——
# 否则每加一条规则都会把自己扫出来（套娃）。仅限隐私工具链自身，不含业务文档。
SELF_REFERENCE_FILES = [
  'scripts/privacy-scan.rb',
  'scripts/privacy-allowlist.txt',
  'scripts/approved-baselines.txt',
].freeze

PATTERNS = [
  %r{/Users/Zhuanz},      # 本机绝对路径
  %r{\b\d{16,19}\b},      # 银行账号（16–19 位）
  %r{\b\d{18}\b},         # 税号（18 位）
  %r{1[3-9]\d{9}},        # 手机号
  %r{\b(?:XK|xk)\d+\b},   # 鱼鹰号（XK 编号）
].freeze

$stdout.sync = true

paths = STDIN.read.split("\0")

def sha256_of(abs)
  Digest::SHA256.file(abs).hexdigest
rescue StandardError
  nil
end

hits = 0
exempted = []
mismatched = []

paths.each do |f|
  next unless File.file?(f)
  next if SELF_REFERENCE_FILES.include?(f) # 隐私工具链自身不参与内容扫描
  begin
    content = File.read(f, mode: 'rb')
  rescue StandardError
    next
  end
  next if content.include?("\x00") # 二进制跳过

  # 先判断该文件是否有命中，避免对无命中文件做 SHA 计算
  file_hits = []
  line_no = 0
  content.lines.each do |raw|
    line_no += 1
    # `mode: 'rb'` 读进来是 ASCII-8BIT；统一转 UTF-8，否则下面的 line_keys
    # （UTF-8，键名含中文文件名）比较会抛 Encoding::CompatibilityError。
    line = raw.dup.force_encoding(Encoding::UTF_8)
    line = raw.dup.force_encoding(Encoding::BINARY) unless line.valid_encoding?
    PATTERNS.each do |re|
      line.scan(re) do |m|
        file_hits << [line_no, m.to_s.strip, line]
      end
    end
  end
  next if file_hits.empty?

  # ---- 条件豁免判定 ----
  exempt = false
  if baselines.key?(f) && !f.start_with?(*NEVER_EXEMPT_PREFIXES)
    expected = baselines[f]
    actual = sha256_of(f)
    if actual == expected
      exempt = true
      exempted << f
    else
      mismatched << [f, expected, actual]
    end
  end
  next if exempt

  file_hits.each do |line_no, frag, line|
    key = "#{f}:#{line_no}"
    next if line_keys.include?(key) || frag_rules.any? { |fr| line.b.include?(fr.b) }
    puts format("%s\t%s", key, frag[0, 60])
    hits += 1
  end
end

mismatched.each do |f, expected, actual|
  puts format('BASELINE-CHANGED %s (expected %s, actual %s)', f, expected, actual)
end

exempted.each { |f| puts "EXEMPT (approved baseline, sha256 ok)\t#{f}" }

if hits.zero? && mismatched.empty?
  puts 'PRIVACY-OK'
else
  puts 'PRIVACY-FAIL'
  exit 1
end
