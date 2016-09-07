module HostingServersHelper
  def os_icon(hosting_server)
    os = HostingServer::OSES[hosting_server.os_id]
    glyphicon_tag(:fl, os.last, title: os.first)
  end

  def mysql_distrib_name(hosting_server)
    HostingServer::MYSQL_DISTRIBS[hosting_server.mysql_distrib_id].first
  end
end
