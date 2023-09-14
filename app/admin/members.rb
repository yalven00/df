ActiveAdmin.register Member do
  #scope :all, :default => true
#  Partner.all.each do |partner|
#    scope partner.name do
#      'Total ' + partner.name + ': ' + Member.where('partner_id = ? AND created_at > ?', partner.id, 1.day.ago).count.to_s
#    end
#  end
  scope :dfm_members do |member|
    @dfm_mem = member.where("partner_id = 0")
  end
  scope :cutekid_members do |member|
   @ck_mem = member.where("partner_id = 1")
  end
  scope :report do |member|
    member.where("partner_id >= 0")
  end

  index do
    if params[:scope].present? and params[:scope]=='report'
      section h2 "Recent Member Counts" do
        if params[:q].nil?  # just retrieve for the last 7 days
          params[:q] = Hash.new
          #last_week = Time.parse((Time.now - 1.week).to_s)
          #today = Time.parse((Time.now).to_s)
          params[:q][:created_at_gte] = (Date.today - 1.week).strftime('%Y-%m-%d').to_s
          params[:q][:created_at_lte] = Date.today.strftime('%Y-%m-%d').to_s

        end

        @totals = Hash.new
        @totals['DFM'] = 0
        @totals['CuteKid'] = 0
        puts params[:q]
        table_for Member.select("COUNT(members.id) as 'Cnt', partners.name as 'Name', DATE(members.created_at) as 'Created'").
           joins("LEFT OUTER JOIN `partners` ON `partners`.`id` = `members`.`partner_id`").search(params[:q]).
           group('date(members.created_at)').group('members.partner_id').order('date(members.created_at) DESC') do
          column('Date'){ |rs| rs.Created.to_s}
          column('Partner'){ |rs|
             partnerName = rs.Name.nil? ? 'DFM' : rs.Name
             @totals["#{partnerName}"]  += rs.Cnt
             partnerName
          }
          column('Count'){ |rs| partnerCount = rs.Cnt.to_s}
        end
      end
      section h2 "Coreg Reports (Optins | Successes)" do

        start_date_time = Time.parse(params[:q][:created_at_gte])
        end_date_time   = Time.parse(params[:q][:created_at_lte])
        start_date  = Date.new(start_date_time.year, start_date_time.month, start_date_time.day)
        end_date    = Date.new(end_date_time.year, end_date_time.month, end_date_time.day)
        x_data = (start_date..end_date).step.reverse
        total_visits_hash = Hash[Request.group('Date(created_at)').select('Date(created_at) as created, count(*) as total').
      where('DATE(created_at) >= ?', start_date).where('DATE(created_at) <= ?', end_date).collect {|x| [x.created.to_s, x.total]}]

        total_members_hash = Hash[Member.group('Date(created_at)').where('partner_id = 0').select('Date(created_at) as created, count(*) as total').
      where('DATE(created_at) >= ?', start_date).where('DATE(created_at) <= ?', end_date).collect {|x| [x.created.to_s, x.total]}]

        total_optins_hash = {}
        coreg_list = []
        CoregOptin.group('Date(created_at), coreg_id').having('total > 0').select('Date(created_at) as created, coreg_id, count(*) as total').
          where(:taken => true).where('DATE(created_at) >= ?', start_date).where('DATE(created_at) <= ?', end_date).each do |x|
	        coreg_list << x.coreg_id
          (total_optins_hash[x.created.to_s] ||= [])[x.coreg_id] = x.total
         end

      total_successes_hash, total_revenue_hash = {}, {}
        CoregOptin.group('Date(created_at), coreg_id').having('total > 0').select('Date(created_at) as created, coreg_id, count(*) as total').
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
      table_for(x_data, :class => 'index_table')  do
        column('Date') { |date| label date.to_s}
        column('DFM Visits') { |date| label total_visits_hash[date.to_s] || 0 }
        column('DFM Members') { |date| label total_members_hash[date.to_s] || 0 }
        column('Revenue') { |date| label number_to_currency(total_summary_hash[date.to_s][3] || 0) }
        column('Revenue Per Member') { |date| label  (m = total_members_hash[date.to_s]) ? number_to_currency((total_summary_hash[date.to_s][3] || 0)/m) : 'N/A' }
        coreg_list.uniq.each do |cog|
          coreg = Coreg.find_by_id(cog)
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

      section h2 "Totals" do
        div do
          "DFM MEMBERS:  #{@totals['DFM']}"
        end
        div do
          "CUTEKID MEMBERS: #{@totals['CuteKid']}"
        end
      end
    else
      column :id, :sortable => :id do |member|
        link_to member.id, admin_member_path(member)
      end
      column :first_name, :sortable => false
      column :last_name, :sortable => false
      column :email
      column "Created", :created_at
    end
  end
end
