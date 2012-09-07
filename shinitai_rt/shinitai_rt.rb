# -*- coding: utf-8 -*-
# 死にたい、とかポストする代わりに、それを含むtweetをRTするよ！
# 10死にたい とかなら10個RTするよ！ 死にたい度が高い時に便利だね！

Plugin.create(:shinitai_rt) do
  service = nil

  onboot do |s|
    service = s
  end

  filter_command do |menu| 
    menu[:shinitai_rt] = {
      :slug => :shinitai_rt,
      :name => '含むtweetをRTする',
      :condition => lambda { |pb| !(pb.widget_post.buffer.text == "") },
      :exec => lambda{ |pb|
        text = pb.widget_post.buffer.text
        if /^(?<num>\d+)(?<query>.*$)/ =~ text
          count = num.to_i
          search_text = query
        else
          count = 1
          search_text = text
        end
#        p count
#        p search_text
        service.search(q: search_text, rpp: count).next{ |res|
          res.each{ |m|
            m.retweet
#            p m.to_s
          }
        }.terminate
      },
      :role => :postbox }
    [menu]
  end
end
