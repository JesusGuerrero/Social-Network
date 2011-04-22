Factory.define :user do |user|
  user.name                  "example"
  user.email                 "user@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.level                 "0"
  user.admin                 "false"
  user.last_tutorial         "0"
end

Factory.define :tutorial do |tutorial|
  tutorial.name      "Website Setup Overview"
  tutorial.category  "website"
  tutorial.permalink "overview"
  tutorial.content   "here's the content"
  tutorial.page_order  "1"
end

Factory.define :website do |website|
  website.domain      "http://www.example.com"
  website.description "example site"
  website.association :user
end

Factory.define :keyword do |keyword|
  keyword.keyphrase "example phrase"
  keyword.description "an example phrase for testing"
  keyword.association :user
end

Factory.define :content do |content|
  content.link_url "http://www.example.com"
  content.association :keyword
end

Factory.define :project do |project|
  project.name "test"
  project.active "true"
  project.basecamp_id "5723374" # test
  project.writer_id "5004530" # Joseph O'Day
  project.linker_id "5004530"
  project.description "test project description"
  project.notes "PR 0"
  project.association :user
end

Factory.define :worker do |worker|
  worker.name "Joseph"
  worker.basecamp_id "5004530"
  worker.category "writer"
end

Factory.sequence :name do |n|
  "person-#{n}"
end

Factory.sequence :basecamp_id do |n|
  "#{n+4}"
end

Factory.define :bc_worker do |worker|
  worker.first_name "Joseph"
end