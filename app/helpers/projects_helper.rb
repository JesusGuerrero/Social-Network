module ProjectsHelper
  
  def completion_status(proj_id)
    Basecamp.establish_connection!('linknetworker.basecamphq.com', 'josephoday', 'theMax2009', true)
    @basecamp = Basecamp.new
    @tdls = Basecamp::TodoList.all(proj_id)
    @mss = @basecamp.milestones(proj_id)
  
    last_ms = nil
    comp_tdi = 0
    html = ""
    @tdls.each do |tdl|
      curr_ms = tdl.milestone_id
      unless curr_ms == last_ms
        ms = @mss.find { |ms| ms.id == curr_ms }
        unless ms == nil
          html << "<tr><td><strong>#{ms.title}</strong></td></tr>"
        end
      end
      total_tdi = tdl.todo_items.count
      tdl.todo_items.each do |tdi|
        if tdi.completed
          comp_tdi += 1
        end
      end
      percent = ((comp_tdi/total_tdi.to_f*100).round)
      width = (percent*2).ceil
      last_ms = curr_ms
      comp_tdi = 0
      html << "<tr><td>#{tdl.name}</td><td>
      <div class='prog-wrap'>
          <div class='prog-value' style='width: #{width}px;'>
              <div class='prog-text'>
                  #{percent}%
              </div>
          </div>
      </div></td></tr>"
    end
    return html
  end
end
