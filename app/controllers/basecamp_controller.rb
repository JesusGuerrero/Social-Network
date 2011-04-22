class BasecampController < ApplicationController
  # Writing 247000
  # Linking 247002
  # Social Profiles 262467
  # Blog Commenting 262468
  # Joseph O'Day 5004530
  
  require 'lib/basecamp.rb'
  
  before_filter :require_user
  before_filter :admin_user
  before_filter :get_project
  
  def project1
    # 5 articles
    @a_count = set_count(@size,5)
    
    # 15 short posts
    @sp_count = set_count(@size,15)
    
    set_writing(@keywords,@a_count,@sp_count,@tdl_writing.id,@tdl_submit.id,@project.writer_id,@project.linker_id)
    
    # 10 web 2.0 profiles
    # set_web_profiles(@size,@keywords,10,@tdl_submit.id,@project.linker_id)
  end
  
  def project2
    # 8 articles
    @a_count = set_count(@size,8)
    
    # 30 short posts
    @sp_count = set_count(@size,30)
    
    set_writing(@keywords,@a_count,@sp_count,@tdl_writing.id,@tdl_submit.id,@project.writer_id,@project.linker_id)
    
    # 8 web 2.0 profiles
    # set_web_profiles(@size,@keywords,8,@tdl_submit.id,@project.linker_id)
    
    # 30 directory submissions
    @num_dirsub = 30
    dirsub(@num_dirsub,@tdl_submit.id,@project.linker_id)
  end
  
  def newproject2
    # 8 articles
    @a_count = set_count(@size,8)
    
    # 25 short posts
    @sp_count = set_count(@size,25)
    
    # 30 directory submissions
    @num_dirsub = 30
    dirsub(@num_dirsub,@tdl_submit.id,@project.linker_id)
    
    @tdl_socprof = todolist(@bc_project.id,262467,@ms.id)
    @tdl_blogcom = todolist(@bc_project.id,262468,@ms.id)
    
    # 24 social profiles
    @num_socprof = 24
    socprof(@num_socprof,@tdl_socprof.id,@project.linker_id)
    
    # 20 blog comments
    @num_blogcom = 20
    blogcom(@num_blogcom,@tdl_blogcom.id,@project.writer_id)
  end
  
  private
  
    def get_project
      @project = Project.find(params[:id])
      @keywords = @project.keywords
      basecamp_connect
      @bc_project = Basecamp::Project.find(@project.basecamp_id)
      @writer = @basecamp.person(@project.writer_id)
      @linker = @basecamp.person(@project.linker_id)
      
      @ms = set_milestone(@bc_project.id)
      @msg = set_message(@bc_project.id)

      @tdl_writing = todolist(@bc_project.id,247000,@ms.id)
      @tdl_submit = todolist(@bc_project.id,247002,@ms.id)

      @size = @keywords.size
    end
  
    def set_milestone(bc_proj_id)
      t = Time.now + (30 * 24 * 60 * 60)
      data = {}
      data["title"] = "Monthly Task Completion for #{t.strftime("%b-%d-%Y")}"
      data["deadline"] = "#{t.strftime("%Y-%m-%d")}"
      data["responsible_party"] = 5004530
      data["notify"] = "true"
      return @basecamp.create_milestone(bc_proj_id,data)
    end
  
    def set_message(bc_proj_id)
      t = Time.now + (30 * 24 * 60 * 60)
      body = "\r\n--------------------------------------\r\n\n"
      @m = Basecamp::Message.new(:project_id => bc_proj_id)
      @m.title = "Keywords for \"Monthly Task Completion for #{t.strftime("%b-%d-%Y")}\""
      @keywords.each do |keyword|
        body << "Keyword: #{keyword.keyphrase}\r\n\nURL: #{keyword.content.link_url}\r\n\nDescription: #{keyword.description}\r\n\n--------------------------------------\r\n\n"
      end
      @m.body = body
      @m.save # => true
      return @m
    end
    
    def todolist(bc_proj_id,template_id,milestone_id)
      @tdl = Basecamp::TodoList.new(:project_id => bc_proj_id)
      @tdl.todo_list_template_id = template_id
      @tdl.milestone_id = milestone_id
      @tdl.tracked = true
      @tdl.save
      return @tdl
    end
    
    def todoitem(todo_list_id,content,worker)
      @tdi = Basecamp::TodoItem.new(:todo_list_id => todo_list_id)
      @tdi.content = content
      @tdi.responsible_party = worker
      @tdi.notify = true
      @tdi.save
      return @tdi
    end
    
    def write_article(keyword,number,todo_list_id,worker)
      content = "Write #{number} article(s) for the following keyword: \"#{keyword}\""
      todoitem(todo_list_id,content,worker)
    end
    
    def submit_article(keyword,link_url,number,todo_list_id,worker)
      content = "Submit #{number} article(s) for the following keyword: \"#{keyword}\" with the following URL: \"#{link_url}\""
      todoitem(todo_list_id,content,worker)
    end
    
    def write_shortpost(keyword,number,todo_list_id,worker)
      content = "Write #{number} short post(s) for the following keyword: \"#{keyword}\""
      todoitem(todo_list_id,content,worker)
    end
    
    def submit_shortpost(keyword,link_url,number,todo_list_id,worker)
      content = "Submit #{number} short post(s) for the following keyword: \"#{keyword}\" with the following URL: \"#{link_url}\""
      todoitem(todo_list_id,content,worker)
    end
    
    def webprofile(keyword1,keyword2,todo_list_id,worker)
      content = "Create 1 Web 2.0 profile for the following keywords: \"#{keyword1.keyphrase}\" + \"#{keyword2.keyphrase}\" with the following URLs: \"#{keyword1.content.link_url}\" + \"#{keyword2.content.link_url}\""
      todoitem(todo_list_id,content,worker)
    end
    
    def dirsub(number,todo_list_id,worker)
      content = "#{number} directory submissions with all project keywords.  Check the Keywords message for all keywords/descriptions"
      todoitem(todo_list_id,content,worker)
    end
    
    def socprof(number,todo_list_id,worker)
      # 1st Pass
      content = "#{number} of 1st pass social profile links."
      todoitem(todo_list_id,content,worker)

      # 2nd Pass
      content = "After 1 week, check on social profiles and perform 2nd pass tasks.  Add links to the project homepage URL."
      todoitem(todo_list_id,content,worker)
    end
    
    def blogcom(number,todo_list_id,worker)
      content = "#{number} blog comments using project homepage URL.  Check the Keywords message for the URL"
      todoitem(todo_list_id,content,worker)
    end
    
    def set_count(size,num_tasks) 
      i = 0
      num_key = size
      @count = Array.new(size,0)
      while i < num_tasks
        if (num_tasks-i) < size
          num_key = num_tasks-i
        end
        for j in 0..num_key-1
          @count[j] += 1
          i += 1
        end
      end
      return @count
    end
    
    def set_writing(keywords,a_count,sp_count,tdl_writing_id,tdl_submit_id,writer_id,linker_id)
      keywords.each_with_index do |keyword, i|
        write_article(keyword.keyphrase,a_count[i],tdl_writing_id,writer_id)
        submit_article(keyword.keyphrase,keyword.content.link_url,a_count[i],tdl_submit_id,linker_id)
        write_shortpost(keyword.keyphrase,sp_count[i],tdl_writing_id,writer_id)
        submit_shortpost(keyword.keyphrase,keyword.content.link_url,sp_count[i],tdl_submit_id,linker_id)
      end
    end
    
    def set_web_profiles(size,keywords,num_prof,tdl_submit_id,project_linker_id)
      k = 0
      @wp_count = Array.new(size,0)
      while k<num_prof
        for i in 0..size-1 do
          for j in i+1..size-1 do  
            if k==num_prof
              break
            else
              webprofile(keywords[i],keywords[j],tdl_submit_id,project_linker_id)
              @wp_count[i] += 1
              @wp_count[j] += 1
              k += 1
            end
          end
          if k==num_prof
            break
          end
        end
      end
      return @wp_count
    end

end
