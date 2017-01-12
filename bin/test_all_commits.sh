set -eu

if [ $1 == '-h' ]; then
    echo "To run a command at every commit between <base> and HEAD:"
    echo "- Set TEST_COMMIT_CMD to the command you want to run"
    echo "- $0 <base>"
    exit 0
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

for commit_id in $(git log --format=%H $1..HEAD); do
    git checkout $commit_id
    $TEST_COMMIT_CMD
done

git checkout $current_branch

