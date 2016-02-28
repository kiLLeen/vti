module VotesHelper
  def top_votes(opts = {})
    hash = Hash.new

    opts[:votes].each do |v|
      first_name = v.try(:account).try(:first_name)
      last_name = v.try(:account).try(:last_name)
      key = first_name + " " + last_name
      hash[key] = hash[key].to_i + v.quantity
    end

    hash = hash.sort_by{ |k, v| -v }.to_a.take(opts[:amount] || 10)
  end
end
