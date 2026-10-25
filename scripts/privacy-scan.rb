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
allowed = Set.new
if File.exist?(allow_path)
  File.readlines(allow_path, encoding: 'UTF-8').each do |l|
    l = l.strip
    next if l.empty? || l.start_with?('#')
    allowed << l
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
  begin
    content = File.read(f, mode: 'rb')
  rescue StandardError
    next
  end
  next if content.include?("\x00") # 二进制跳过

  # 先判断该文件是否有命中，避免对无命中文件做 SHA 计算
  file_hits = []
  line_no = 0
  content.lines.each do |line|
    line_no += 1
    PATTERNS.each do |re|
      line.scan(re) do |m|
        file_hits << [line_no, m.to_s.strip]
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

  file_hits.each do |line_no, frag|
    key = "#{f}:#{line_no}"
    next if allowed.include?(key) || allowed.include?(frag)
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
