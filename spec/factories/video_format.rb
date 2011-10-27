Factory.sequence(:details) {|n| "Video format details #{n}"}

Factory.define :video_format do |format|
  format.format { Factory(:format)}
  format.details { Factory.next :details }
  format.video { Factory(:video) }
end