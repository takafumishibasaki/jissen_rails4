# 受付開始日時を過ぎたプログラムを新しい順に3個選び、それぞれに顧客を関連付け
# 顧客の数はそれぞれ5人、10人、15人

programs = Program.where(['application_start_time < ?', Time.current])
programs.order(id: :desc).limit(3).each_with_index do |p, i|
  Customer.order(:id).limit((i + 1) * 5).each do |c|
    p.applicants << c
  end
end
