module Roadmap

  def get_roadmap(roadmap_id)
    addr  = "/roadmaps/#{roadmap_id}"
    options = {headers: {'authorization' => @token}, body: {id: 0}}
    response = JSON.parse(self.class.get(addr, options).to_s)
#collects sections and checkpoints
    response.select!{|k,v| k == "sections"}
    a = response["sections"]
    a.each do |section|
      #response_to_file("section_#{section["id"]}", section )
      puts "Section #{section["id"]}"
      section["checkpoints"].each do |checkpoint|
        #response_to_file("checkpoint_#{checkpoint["id"]}", checkpoint)
        puts "Checkpoint #{checkpoint["id"]}"
      end
    end
    puts "done"
  end

  def get_checkpoint(checkpoint_id)
    addr  = "/checkpoints/#{checkpoint_id}"
    options = {headers: {'authorization' => @token}}
    response = JSON.parse(self.class.get(addr, options).to_s)
    
  end

  private
  def response_to_file(name, jsondata)
    File.open("#{name}.js","w") do |f|
      f.write(jsondata)
    end
  end

end
