#!/usr/bin/ruby
#
#collects geocaches from http://opencaching.org.uk
#stores them into our geocache site database

require 'mysql'
require 'net/http'
require 'rubygems'
require 'xmlsimple'

#database connection constants
#
CRON_ID   = 1
LOCALHOST = 'localhost'
USERNAME  = 'root'
PASSWORD  = '$martb0y'
DATABASE  = 'bountyhunter_development'
ITEMS_PER_PAGE = 50
BASE_URL  = 'http://www.opencaching.org.uk/search.php'
SEARCH_CONDITIONS = "searchto=searchbydistance&showresult=1&output=XML&sort=byname&f_inactive=1&f_userowner=1&latNS=N&lat_h=50&lat_min=33.123&lonEW=W&lon_h=3&lon_min=40.123&distance=550&unit=km&count=#{ITEMS_PER_PAGE}&startat="
INSERT_STRING     = "INSERT INTO geocaches (user_id, opencache_id, name, owner, created_at, status, lon, lat, geo_type, difficulty, terrain, size, notes) VALUES ('1', '[1]', '[2]', '[3]', '[4]', '[5]', '[6]', '[7]', '[8]', '[9]', '[10]', '[11]', '[12]')"

def convert_to_decimal(location)
    location.gsub(/([A-Z]) (\d+)° (\d.+)'/) do
        case $1
        when "N"
            multiplier = 1
        when "S"
            multiplier = -1
        when "E"
            multiplier = 1
        when "W"
            multiplier = -1
        end
        @r = ($2.to_f + ($3.to_f/60)) * multiplier
    end
    @r
end

#get database connection handle
#
def connect_to_database
    puts "connecting to database.."
    Mysql.real_connect(LOCALHOST, USERNAME, PASSWORD, DATABASE)
end

#get last cron processed value 
#
def get_last_value(dbh)
    res = dbh.query("SELECT increment_value_traker FROM cron_traker")
    @r = nil
    res.each do |row|
        @r = row[0]
        puts "---#{@r}"
    end
    res.free
    puts "got last value of cron traker: #{@r}"
    @r
end

#create cron_traker entry
#
def create_cron_entry(dbh)
    puts "creating an entry for cron id #{CRON_ID}"
    res = dbh.query("INSERT INTO cron_traker (cron_id, increment_value_traker) VALUES ('#{CRON_ID}', '0')")
end


#set last cron processed value
#
def set_last_value(dbh)
    last_value = get_last_value(dbh)
    if last_value.nil? or last_value.empty?
        create_cron_entry(dbh)
        last_value=0
    end
    res = dbh.query("UPDATE cron_traker SET increment_value_traker='#{(last_value.to_i + 1)}' WHERE cron_id='#{CRON_ID}'")
    puts "update cron_traker for cron job #{CRON_ID} to #{(last_value.to_i + 1)}"
end

#get last opencache_id from geocaches database
#
def get_last_geocache_id(dbh)
    print "getting last opencache id.."
    res = dbh.query("SELECT max(opencache_id) as 'opencache_id' FROM geocaches")
    res.each do |row|
        @r = row[0]
    end
    res.free
    @r = 1 if @r.nil? or @r.empty?
    print "..#{@r}\n"
    @r
end

#nasty way of escaping single quotes
#
def escape_string(str)
    puts "escaping string"
    str.gsub(/'/,"").gsub(/\\/,"")
end

def convert_hash_to_query(geocache)
    query = String.new INSERT_STRING
    query.gsub!('[1]', escape_string(geocache["id"]))
    query.gsub!('[2]', escape_string(geocache["name"]))
    query.gsub!('[3]', escape_string(geocache["owner"]))
    query.gsub!('[4]', escape_string(geocache["hidden"]))
    query.gsub!('[5]', escape_string(geocache["status"]))
    query.gsub!('[6]', escape_string(geocache["lon"]))
    query.gsub!('[7]', escape_string(geocache["lat"]))
    query.gsub!('[8]', escape_string(geocache["type"]))
    query.gsub!('[9]', escape_string(geocache["difficulty"]))
    query.gsub!('[10]', escape_string(geocache["terrain"]))
    query.gsub!('[11]', escape_string(geocache["size"]))
    query.gsub!('[12]', "#{escape_string(geocache["desc"])} - #{escape_string(geocache["hints"])}")
    puts query
    query
end

#store the opencache data in database
#
def store_data(dbh, data)
    puts "storing data.."
    data.each_pair do |k,v|
        query = convert_hash_to_query(v)
        dbh.query(query)
        puts "Stored opencache geocache id #{v["id"]}" if dbh.affected_rows > 0
        set_last_value(dbh)
    end
end

#get the XML data as a string
#
def get_xml_data(startat_value)
    puts "getting xml data"
    url = "#{BASE_URL}?#{SEARCH_CONDITIONS}#{startat_value}"
    Net::HTTP.get_response(URI.parse(url)).body
end

#extract geocaches information
#
def extract_data_from_xml(xml_data)
    puts "extracting data"
    data = XmlSimple.xml_in(xml_data)
    record_count = data['docinfo'][0]['results'][0]
    puts "found #{record_count} geocaches"
    return if record_count.nil? || record_count.empty? || record_count.to_i < 1
    @geocaches = Hash.new
    data['cache'].each_with_index do |item,idx|
        @geocache = Hash.new
        puts "=[#{idx}]========="
        item.sort.each do |k,v|
            if ["id", "name", "owner", "hidden", "status", "lon", "lat", "type", "difficulty", "terrain", "size", "desc", "hints"].include? k
                if k=="lat" || k=="lon"
                    @geocache[k] = convert_to_decimal(v[0]).to_s
                else
                    @geocache[k] = v[0].to_s.strip
                end
            end
        end
        puts @geocache.inspect
        @geocaches[idx] = @geocache
    end
    @geocaches
end

begin
    puts "starting data collection and processing"

    dbh = connect_to_database
      exit(0) if dbh.nil?

    last_opencache_row_value = get_last_value(dbh)
    xml_data = get_xml_data(last_opencache_row_value)
    data     = extract_data_from_xml(xml_data)
    store_data(dbh, data)
    puts "finished data collection and processing"
rescue Mysql::Error => e
    puts "Error code: #{e.errno}"
    puts "Error message: #{e.error}"
    puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
    # disconnect from server
    dbh.close if dbh
end
