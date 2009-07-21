namespace :ferret do

  # Rebuild index task. Declare the indexes to be rebuilt with the INDEXES
  # environment variable:
  #
  # INDEXES="my_model shared" rake ferret:rebuild
  desc "Rebuild a Ferret index. Specify what model to rebuild with the INDEXES environment variable."
  task :rebuild => :environment do
    
    # TODO (JL): presumably commented out support for indexes defined in config/aaf.rb (suvh as shared indexes)
    # This should be done so that both models with 'acts_as_ferret' and shared indexes are hendled.
    
    # indexes = ENV['INDEXES'].split
    # indexes.each do |index_name|
    #   start = 1.minute.ago
    #   ActsAsFerret::rebuild_index index_name
    #   idx = ActsAsFerret::get_index index_name
    #   # update records that have changed since the rebuild started
    #   idx.index_definition[:registered_models].each do |m|
    #     m.records_modified_since(start).each do |object|
    #       object.ferret_update
    #     end
    #   end
    # end

    models = ENV['INDEXES'].split.map(&:constantize)
 
    start = 1.minute.ago
    models.each { |m| m.rebuild_index }
 
    # update records that have changed since the rebuild started
    models.each do |m|
      m.records_modified_since(start).each do |object|
        object.ferret_update
      end
    end

  end
end
