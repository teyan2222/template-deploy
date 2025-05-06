#!/bin/sh
# ./push_to_branch.sh <registry> <branch> <tag>
git config user.name "github-actions[bot]"
git config user.email "bot@users.noreply.github.com"
registry=$1
branch_name=$2
tag=$3
new_branch=0
git checkout $branch_name
if [ $? ]; then 
  new_branch=1 
fi
echo $registry $branch_name $tag 
if [ $new_branch ]; then 
  git branch $branch_name
  git checkout $branch_name
fi
./scripts/build.sh -r $registry -t $tag
git add ./deploy/*
git commit -m "Update image $tag"
if [ $new_branch ]; then
  git push --set-upstream origin $branch_name
else
  git push
fi
