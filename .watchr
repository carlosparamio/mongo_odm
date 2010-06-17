# Watchr is the preferred method to run specs automatically over rspactor for
# MongoModel.

def run(cmd)
  puts cmd
  system cmd
end

def spec(file)
  run "spec #{file}"
end

watch("spec/.*/*_spec\.rb") do |match|
  p match[0]
  spec(match[0])
end

watch('lib/(.*/.*)\.rb') do |match|
  p match[1]
  spec("spec/#{match[1]}_spec.rb")
end
