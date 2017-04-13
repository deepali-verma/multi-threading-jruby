require 'rubygems'
require 'java'

java_import 'java.util.concurrent.Callable'
java_import 'java.util.concurrent.FutureTask'
java_import 'java.util.concurrent.LinkedBlockingQueue'
java_import 'java.util.concurrent.ThreadPoolExecutor'
java_import 'java.util.concurrent.TimeUnit'

# class having executable code for thread
class SampleThread
  include Callable

  def initialize(name)
    @name = name
  end

  def call
    puts "Starting thread - #{@name}"
    10.times do |i|
      puts "printing #{i} from #{@name}"
    end
  end
end

executor = ThreadPoolExecutor.new(4, # core_pool_treads
                                  4, # max_pool_threads
                                  60, # keep_alive_time
                                  TimeUnit::SECONDS,
                                  LinkedBlockingQueue.new)

num_threads = 2

tasks = []
t0 = Time.now
num_threads.times do |c|
  task = FutureTask.new(SampleThread.new("thread #{c}"))
  executor.execute(task)
  tasks << task
end

tasks.each(&:get)
t1 = Time.now

time_ms = (t1 - t0) * 1000.0
puts "Time elapsed = #{time_ms}ms"
executor.shutdown
