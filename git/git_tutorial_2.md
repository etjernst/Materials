## Introducing branches

Branches are the killer feature of git. It's what distinguishes git as a powerful collaboration tool.<br>
<br>
Branches = time travel & parallel universes:
* Branches enable different people to work on the same thing at the same time.
* Branches enable you to view different versions of your files.
* In fact, branching allows you to _move forwards or backwards in time_; and to move "horizontally" in time through various concurrent versions.
* You can essentially take a snapshot of your existing repo and try out a whole new idea without affecting your main 
(i.e. "master") branch.
* Once you (and your collaborators) are 100% satisfied, then you can merge this new test code back into the master branch.
* This is how most new features in modern software and apps are developed but researchers can easily us it.
* Say you want to try a new way of creating a variable and see how that changes results.
You can do that in a branch in order to not mess up the master branch. 
If you like the result you can merge your experiment with the main version of the code.
If you aren't happy, then you can just delete the experimental branch and continue as if nothing happened.
<br>

![Branches](https://github.com/etjernst/Materials/blob/master/branches.png)

<br>
Research is a highly nonlinear process, and this way of doing version control is much more similar to how we actually work
than the very linear way that Dropbox (for example) does version control.<br>
We will mostly use branches with our names. But a branch can also be called something specific like newvardef.<br>

To make sure we know what we are doing, we need to organize our commits and branches.<br>
This is non-trivial.<br>
You have to think in ways you are not used to thinking when you start
using Git, so these workflows will not feel intuitive.<br>
But they are worth learning, since Git will be less useful otherwise.<br>

We will use a few main branches:
1. [master] branch: protected, always "ready to run", and has sparse commits from [working]
2. [working] branch is protected, "nearly" ready to run, and has frequent commits from [user] or [feature] branches
3. [user] or [feature] branches are frequent, specific, personal, and hold all new work

## Step 1 - Make a branch

It will be easiest to collaborate if we work on different branches. I will mix in some research tips below as well.

1. Create a branch on your local computer and switch to it. Let's call this branch "cheese".<br>
`git checkout -b [NAME-OF-YOUR-NEW-BRANCH]`
2. Push the new branch to GitHub (to let your collaborators know that it exists).<br>
`git push origin [NAME-OF-YOUR-NEW-BRANCH]`
3. List all branches on your local machine.<br>
`git branch`
4. Let's say that you decide that you no longer want to keep the branch. Delete it.<br>
`git branch -d [NAME-OF-YOUR-FAILED-BRANCH]`
`git push origin :[NAME-OF-YOUR-FAILED-BRANCH]`
5. Make a new branch called [your-name] following steps 1-3. Open our repo on GitHub and look for your branch.
6. Search [google schoolar](https://scholar.google.com) for the below paper
7. Add the pdf (you should be able to access it from campus) to a new folder in your branch on your local clone. 
Call the folder Literature.
8. Click on the link below the article saying "Cited by"
![google-scholar](../lemons.png)

9. Select the box that says "Search within citing articles" and search for "Kenya"
(this is a great way to find more papers -- if you know one paper that you like, you can find more recent ones that cite it).
10. Pick a paper that sounds interesting, and add that to the literature folder as well.
11. Stage and commit (with comments) the changes that you have made so far (see below for some nice shortcuts)
12. Add a file inside the Various folder (on your branch in your local clone) called tanvi_updates.md
(you should be able to just open a new file text editor and then save the file with the .md file extension)
13. Type the date and add a short summary of what you just did. Feel free to add any questions here too.
14. Stage these changes, too.
15. Commit (with comments) and push your changes.
   > _Don't forget to pull first & check the status of the local repo!_
16. Go to our repo on GitHub and look for your changes. Don't see them? 
Look for a tab that says branches and switch to your branch. You should see them now.<br>
   > What do you see?

### Some more git commands that might be useful at this point
`git add -A` _stage all files_ <br>
`git add -u` _stage updated files only (i.e., modified or deleted, but not new)_ <br>
`git add .` _stage new files only (i.e. not updated)_ <br>
<br>
If you mess up but don't want to delete your branch, you can "overwrite" your branch with
what is on the master. Make sure you are on your branch:<br>
`git checkout [yourbranch]` <br>
Then basically overwrite it with the info on the master: <br>
`git pull origin master` <br>

### Some more branch-related options
If you want to switch back to the master branch (or any other branch)<br>
`git checkout master` <br>
You can see what branch that you are at the end of the bottom line (in blue parentheses, at least on Windows) in git bash: <br>
![git-bash](https://github.com/etjernst/Materials/blob/master/branch-checkout.png)

<br>

_Sources:_<br>
* Grant McDermott's great [lecture notes](https://github.com/uo-ec607/lectures)
* [Resources](https://github.com/worldbank/DIME-Resources) from the World Bank's DIME unit 
