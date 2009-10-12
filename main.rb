#!/usr/bin/env ruby1.9
require(File.join(File.dirname(__FILE__), 'config', 'environment.rb'))

# Rake::Task['remigrate'].invoke

structure_map = StructureMap.new
predictor = Predictor.new
learner = Learner.new
activity_map = ActivityMap.new



puts "Type a sentence and hit enter:\n\n"

while (ch=STDIN.getc)!=nil
  ch = ch.chr if ch.is_a?(Integer)
  if ch =~ /(\d|\w|\ )/
    ch = $1.downcase!
    
    activity_map.update_activity(ch)
    learner.learn
    
    puts "\n--------------------\n\n"
  end
end

puts "\nclosing...\n"
