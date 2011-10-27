Factory.sequence(:title) {|n| "Video #{n}"}
Factory.sequence(:description) {|n| "Video discription #{n}"}
Factory.sequence(:slug) {|n| "Video slug #{n}"}

Factory.define :video do |video|
  video.title { Factory.next :title }
  video.slug { Factory.next :slug }
  video.description { Factory.next :description }
end