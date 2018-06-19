class RedisStateWorker
    include Sidekiq::Worker
    
    def perform()
        logger.info "Redis State Worker is Running"
        setStateKeys()
    end    
    
    def setStateKeys()
        RedisSetStateKeys.set_state_keys()
    end  
end