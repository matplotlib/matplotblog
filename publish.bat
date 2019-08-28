echo "Deleting old publication"
rmdir /s public
mkdir public
git worktree prune
rmdir /s .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rmdir /s public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
#cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

#echo "Pushing to github"
#git push --all
