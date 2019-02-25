
require 'date'

# Zero hour for the entire challenge (y,m,d,h,M,s)
Z = Time.new(2018,12,24,23,59,59)

times = {
  # rtp
  "christmas_coming_music.pcapng" => Z,
  "grinch_music.pcapng" => Z + 159,
  "skating_music.pcapng" => Z + 253,


  # smtp
  "e-mail_charlie_brown.pcapng" => Z + 1,
  "e-mail_jim_carrey.pcapng" => Z + 125,

  # browsing is all +10
  "grinch_browsing_wikipedia_grinch.pcapng" => Z + 10 + 2,
  "grinch_browsing_blog_vpn_leak.pcapng" => Z + 10 + 3,
  "grinch_browsing_imdb.pcapng" => Z + 10 + 39,
  "grinch_browsing_blog_memcache.pcapng" => Z + 10 + 34,
  "grinch_browsing_blog_bittorrent.pcapng" => Z + 10 + 69,
  "grinch_browsing_10_reasons.pcapng" => Z + 10 + 70,
  "grinch_browsing_wikipedia_rot13.pcapng" => Z + 10 + 80,
  "grinch_browsing_blog_tcp_fast_open.pcapng" => Z + 10 + 92,
  "grinch_browsing_blog_ssl_key_logging.pcapng" => Z + 10 + 123,
  "grinch_browsing_make_reindeer.pcapng" => Z + 10 + 124,
  "grinch_browsing_bing_search.pcapng" => Z + 10 + 130,
  "grinch_browsing_cyberchef.pcapng" => Z + 10 + 157,
  "mads_photo_upload.pcapng" => Z + 10 + 168,

  # grinch chat is all + 25, spaced by 25 sec
  "grc_chunk_1.pcapng" => Z + 25 + 0,
  "grc_chunk_2.pcapng" => Z + 25 + 25,
  "grc_chunk_3.pcapng" => Z + 25 + 50,
  "grc_chunk_4.pcapng" => Z + 25 + 75,
  "grc_chunk_5.pcapng" => Z + 25 + 100,
  "grc_chunk_6.pcapng" => Z + 25 + 125,


  # memcache
  "storing_chunk_in_memcache.pcapng" => Z + 80,
  # bt_tracker
  "grinch_torrent_file_upload.pcapng" => Z + 111,
  # threat trigger
  "xmas_exfiltration.pcapng" => Z + 203,
  # vpn trafic
  "grinch_vpn_traffic.pcapng" => Z + 310

}

def get_skew(file)
  raw_start = `capinfos -aT #{file}`.lines.last.split.last(2).join(" ")
end

`mkdir -p skewed`

count = 0
times.sort_by{|k,v| v}.to_h.each_pair do |k,v|
  skew = get_skew(k)
  old_start = DateTime.parse(skew).to_time
  diff = (v - old_start).to_i

  puts "#{k.ljust(40)}\t#{v}\t\t#{skew}\t#{old_start}\t#{diff}"

  system "editcap -t #{diff} #{k} skewed/#{k}"
  count +=1
end

puts "Processed #{count} files."

