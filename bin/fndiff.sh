set -eu

# this won't work with space in the filenames. fuck bash.

pattern=$1

candidates=$(find . -name $pattern)

if [ $(echo $candidates | wc -w) -lt 3 ]; then
    exec vimdiff $candidates
fi

echo "Select file 1"
select file1 in $candidates; do
    break;
done

echo "Select file 2"
select file2 in $candidates; do
    break
done

exec vimdiff $file1 $file2
