
#sets aliases for course exercise directories. (CS UoM)
for course in `ls ~ | grep "^COMP"`
do
  alias `echo $course | cut -c 5-7`="cd ~/$course"
  for ex in `ls ~/$course | grep "^ex"`
  do
    alias `echo $course | sed -e s/COMP// | sed -e s/..$//``echo $ex | sed -e s/ex//`="cd ~/$course/$ex"
  done
done
