ActiveAdmin::Dashboards.build do
 
  section "Today", :priority => 1 do
    div do
      'Total Members Joined ' + Member.joined_today.to_s
    end
    div do
      'Total DFM: ' + Member.where('partner_id = 0 AND created_at > ?', Date.today.strftime('%Y-%m-%d').to_s ).count.to_s
    end
    div do
      Partner.all.each do |partner|
       div do 'Total ' + partner.name + ': ' + Member.where('partner_id = ? AND created_at > ?', partner.id, Date.today.strftime('%Y-%m-%d').to_s ).count.to_s end
      end
    end
  end

  section "Monthly Chart", :priority => 2 do
    t = ::Time.now.in_time_zone
    div do
      'Total DFM: ' + Member.where('partner_id = 0 AND created_at > ?', t.beginning_of_month).count.to_s
    end
    Partner.all.each do |partner|
      div do 'Total ' + partner.name + ': ' + Member.where('created_at >= ? AND partner_id = ?', t.beginning_of_month, partner.id).count.to_s end
    end
  end
  
  section "Total Members", :priority => 3 do
    div do
      'Total Members Joined ' + Member.count.to_s
    end
    div do
      'Total DFM: ' + Member.where('partner_id = 0').count.to_s
    end
    div do
      Partner.all.each do |partner|
       div do 'Total ' + partner.name + ': ' + Member.where('partner_id = ?', partner.id).count.to_s end
      end
    end
  end
  
  section "Members Last 30 days", :priority => 4 do
    div do
       t = ::Time.now.in_time_zone
       result = Member.select("COUNT(members.id) as 'Cnt', partners.name as 'Name', DATE(members.created_at) as 'Created'").
         joins("LEFT OUTER JOIN `partners` ON `partners`.`id` = `members`.`partner_id`").where("members.created_at >= ?", t - 30.days).
         group('date(members.created_at)').group('members.partner_id').order('date(members.created_at) DESC')
       table_for result do
           column('Date'){ |rs| link_to(rs.Created.to_s, '/admin/members?commit=Filter&amp;order=id_desc&amp;page=1&amp;q[created_at]='+rs.Created.to_s+'&amp;q[dob_gte]=&amp;q[dob_lte]=&amp;q[email_contains]=&amp;q[first_name_contains]=&amp;q[gender_contains]=&amp;q[ip_address_contains]=&amp;q[last_name_contains]=&amp;q[partner_id_eq]=&amp;q[password_contains]=&amp;q[postal_code_contains]=&amp;q[salt_contains]=&amp;q[updated_at_gte]=&amp;q[updated_at_lte]=&amp;scope=&amp;utf8=%E2%9C%93')}
           column('Partner'){|rs| rs.Name.nil? ? 'DFM' : rs.Name }#+ ': ' + rs.Cnt.to_s end
           column('Count'){|rs| rs.Cnt.to_s}
       end
    end
  end

  section "Coreg Reports (Optins | Successes)", :priority => 10 do
    end_date = Date.today
    start_date = end_date - 7.day

    x_data = (start_date..end_date).step.reverse

    total_visits_hash = Hash[Request.group('Date(created_at)').select('Date(created_at) as created, count(*) as total').
      where('DATE(created_at) >= ?', start_date).where('DATE(created_at) <= ?', end_date).collect {|x| [x.created.to_s, x.total]}]

    total_members_hash = Hash[Member.group('Date(created_at)').where('partner_id = 0').select('Date(created_at) as created, count(*) as total').
      where('DATE(created_at) >= ?', start_date).where('DATE(created_at) <= ?', end_date).collect {|x| [x.created.to_s, x.total]}]

    total_optins_hash = {}
    CoregOptin.group('Date(created_at), coreg_id').select('Date(created_at) as created, coreg_id, count(*) as total').
      where(:taken => true).where('DATE(created_at) >= ?', start_date).where('DATE(created_at) <= ?', end_date).each do |x|
	    (total_optins_hash[x.created.to_s] ||= [])[x.coreg_id] = x.total
    end 

    total_successes_hash, total_revenue_hash = {}, {}
    CoregOptin.group('Date(created_at), coreg_id').select('Date(created_at) as created, coreg_id, count(*) as total').
      where(:success => true).where('DATE(created_at) >= ?', start_date).where('DATE(created_at) <= ?', end_date).each do |x|
	    (total_successes_hash[x.created.to_s] ||= [])[x.coreg_id] = x.total
      revenue = Coreg.find(x.coreg_id).try(:revenue) || 0 rescue 0
	    (total_revenue_hash[x.created.to_s] ||= [])[x.coreg_id] = x.total* revenue
    end 

    total_summary_hash = {}
    x_data.reverse.collect(&:to_s).each do |date| 
      total_summary_hash[date] = [ 
        total_members_hash[date] || 0, 
        (total_optins_hash[date] || []).inject{|sum,x| (sum || 0) + (x || 0) } || 0, 
        (total_successes_hash[date] || []).inject{|sum,x| (sum || 0) + (x || 0) } || 0, 
        (total_revenue_hash[date] || []).inject{|sum,x| (sum || 0) + (x || 0) } || 0, 
      ]
    end

    #puts total_summary_hash.inspect

    div do
      table_for(x_data) do
        column('Date') { |date| label date.to_s}
        column('DFM Visits') { |date| label total_visits_hash[date.to_s] || 0 }
        column('DFM Members') { |date| label total_members_hash[date.to_s] || 0 }
        column('Revenue') { |date| label number_to_currency(total_summary_hash[date.to_s][3] || 0) }
        column('Revenue Per Member') { |date| label  (m = total_members_hash[date.to_s]) ? number_to_currency((total_summary_hash[date.to_s][3] || 0)/m) : 'N/A' }
        Coreg.all.each do |coreg|
          column("#{image_tag(coreg.image.url(:thumb), :size => '48x48') } #{coreg.name} <br/> #{number_to_currency coreg.revenue} (#{coreg.screen_key})".html_safe) do |date|  
            members = total_members_hash[date.to_s] || 0
            optins = total_optins_hash[date.to_s].try(:at, coreg.id) || 0
            successes = total_successes_hash[date.to_s].try(:at, coreg.id) || 0
            total_revenue = successes * coreg.revenue
            if members == 0
              label "N/A".html_safe
            else
              label "#{optins} (#{ optins*100/members }%) <br/> #{successes} (#{ successes*100/members }%) #{number_to_currency total_revenue}".html_safe
            end
          end
        end
      end
    end

    div do
      image_tag Gchart.line(:size => '900x200', 
            :title => "example title",
            :bg => 'efefef',
            :legend => ['members', 'optins', 'successes'],
            :line_colors => ["FF0000", "00FF00", "0000FF"],
            :axis_with_labels => 'x,r',
            :axis_labels => [total_summary_hash.keys.join('|')],
            :data => [ total_summary_hash.values.collect {|x| x[0]} , total_summary_hash.values.collect {|x| x[1]}, total_summary_hash.values.collect {|x| x[2]}] )
    end
  end
  
 section "Past Months", :priority => 5 do
  end_date = Date.today
  start_date = end_date - 7.day
  div do
    link_to('Past Month Results',"/admin/members/?q[created_at_gte]=#{start_date}&q[created_at_lte]=#{end_date}")
  end
   #SELECT COUNT(members.id) as 'Cnt', YEAR(members.created_at), MONTH(members.created_at) FROM `members` LEFT OUTER JOIN `partners` ON `partners`.`id` = `members`.`partner_id` GROUP BY YEAR(members.created_at), MONTH(members.created_at)
 end 

 section "Placeholder", :priority => 6 do
   #SELECT COUNT(members.id) as 'Cnt', YEAR(members.created_at), MONTH(members.created_at) FROM `members` LEFT OUTER JOIN `partners` ON `partners`.`id` = `members`.`partner_id` GROUP BY YEAR(members.created_at), MONTH(members.created_at)
 end 

end
