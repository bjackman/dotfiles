set -eu

current_branch=$(git rev-parse --abbrev-ref HEAD)

for commit_id in $(git log --format=%H $1t reb..HEAD); do
    git checkout $commit_id
    $TEST_COMMIT_CMD
done

git checkout $current_branch

