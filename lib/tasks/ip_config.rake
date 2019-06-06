namespace :ip_config do
  desc "Adicionar IP"
  task :set_ip, [:ip, :state, :start_time, :end_time] => :environment do |t, args|
    args.with_defaults(state: true)
    args.with_defaults(start_time: "08:00")
    args.with_defaults(end_time: "18:00")
    if !args[:ip] || args[:ip] == ""
      puts "Necessário digitar o IP( rails set_ip[1.2.3.4] )" 
    else
      begin
        IpList.create(
          ip: args[:ip],
          state: args[:state],
          start_time: args[:start_time],
          end_time: args[:end_time]
        )
        puts "cadastrado com sucesso" 
      rescue => exception
        puts exception
      end
    end
  end

  desc "Alterar IP"
  task :update_ip, [:ip, :state, :start_time, :end_time] => :environment do |t, args|
    args.with_defaults(state: true)
    if !args[:ip] || args[:ip] == ""
      puts "Necessário digitar o IP( rails set_ip[1.2.3.4] )" 
    else
      update = IpList.where(ip: args[:ip]).first
      update.state = args[:state] if args[:state] != "" 
      update.start_time = args[:start_time] if args[:start_time] != "" 
      update.end_time = args[:end_time] if args[:end_time] != "" 
        
      begin
        update.save
        puts "IP atualizado com sucesso"
      rescue => exception
        puts exception
      end
    end
  end
end
