desc "Generate site."
task :generate do
  sh "jekyll"
end

desc "Deploy live site."
task :deploy => :generate do
  sh "rsync -avz --delete site/ peeja_passfail-info@ssh.phx.nearlyfreespeech.net:/home/public"
end
