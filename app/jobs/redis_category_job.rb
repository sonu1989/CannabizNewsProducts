class RedisCategoryJob < ActiveJob::Base
    include SuckerPunch::Job
    
    def perform()
        puts 'Redis Category Job is Running'
        RedisSetCategoryKeys.new().set_category_keys()    
    end
end