task :sync => :environment do
  `ssh mattmatt@cardero.textdrive.com "mysqldump -u dramasoc -p dramasoc | bzip2 " | bzcat | mysql -u root dramasoc`
end
