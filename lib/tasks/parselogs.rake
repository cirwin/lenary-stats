namespace :log do
  desc "Parses logfiles"
  task :parse => :environment do
      
    file = "#{RAILS_ROOT}/log/#{RAILS_ENV}.log"
    
    if ! File.exists? file 
      puts "FATAL: #{file} does not exist."
    else
      params = {}
      status = 200
      IO.readlines(file).each do |line|
        if status == 500 and /([^\:]*\:\:[^\:]*)\: (.+)/
          params[:error] = $1
          params[:exception_string] = $2
         
        elsif status == 501 
          if line=~ /^\s*$/
            status = 200
          else
            params[:stack_trace] ||= ""
            params[:stack_trace] += line
          end
        elsif line =~ /Processing ([^#]+)#([^ ]+) \(for ([^ ]+) at ([^\)]+)\) \[[^\]]+\]/
          if params
            Stat(params).save!
            puts params.inspect
            params = {}
          end
          params[:controller] = $1
          params[:action] = $2
          params[:for] = $3
          params[:at] = $4
          params[:method] = $5
        elsif line =~ /Session ID: (.+)/
          params[:session_id] = $1
        
        elsif line =~ /Parameters: \{([^\}]*)\}/
          params[:params] = $1
          
        elsif line =~ /Completed in ([\d\.]+) (.*) \| (\d+) [^\[]* \[[^\/]*\/\/[^\/]*([^\]]+)\]/
          params[:total] = $1
          params[:status] = $3
          params[:path] = $4
          
          times = $2
          params[:render] = $1 if times =~ /Rendering: ([\d\.]+)/
          params[:db] = $1 if times =~ /DB: ([\d\.]+)/
        elsif line =~ /Status: 500/
            status = 500
        end
      end
    end
  end
end 