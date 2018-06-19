class RedisStateJob < ActiveJob::Base
    include SuckerPunch::Job
    
    def perform()
        puts 'Redis State Job is Running'
        RedisSetStateKeys.new().set_state_keys()    
    end
end