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
<br>

We will now start working with our main repo (instead of Tutorials). 
Repeat this subset of steps from tutorial 1,  replacing file_paths as relevant:
   
## Step 0 (b) - Clone the relevant repo into a local directory on your computer

1. Set the working directory to where you want to work from (again, you can either type the filepath or drag and drop the 
folder onto the git bash window) _This can be anywhere on your local computer._<br>
    `cd [filepath/drag file]`
  or<br>
    `cd [localfilepath]`
2. Tell git to clone everything that is on GitHub to a local directory 
(this will create a folder called Tutorials wherever you pointed to in the above command)<br>
    `git clone [file_path_here]`    _replace [file_path_here] with the repo we will work in_
3. Now you want git bash to use that folder as your working directory, so tell it to do that<br>
    `cd [repo_name]`    _replace [repo_name] with our repo name_
<br>

## Step 1 - Make a branch

It will be easiest to collaborate if we work on different branches.<br>
I have protected the master branch so you will not be able to push to it.<br>
_I will mix in some research tips below as well._

1. Create a branch on your local computer and switch to it. Let's call this branch "cheese".<br>
    `git checkout -b [NAME-OF-YOUR-NEW-BRANCH]`
2. Push the new branch to GitHub (to let your collaborators know that it exists).<br>
    `git push origin [NAME-OF-YOUR-NEW-BRANCH]`
3. List all branches on your local machine.<br>
    `git branch`
4. Let's say that you decide that you no longer want to keep the branch. Maybe cheese wasn't the best name. Delete it:<br>
    `git branch -d [NAME-OF-YOUR-FAILED-BRANCH]`
    `git push origin :[NAME-OF-YOUR-FAILED-BRANCH]`
    > Now the _origin_ repo on GitHub knows that you have deleted your branch.
5. Make a new branch called [your-name] following steps 1-3. Open our repo on GitHub and look for your branch. Do you see it?
6. Search [google schoolar](https://scholar.google.com) for the below paper.
7. Add a folder using `mkdir` as in the other tutorial. Call the folder Literature. (You are now adding this folder _in your branch on your local clone_).
8. Back in your browser, click on the "Cited by" link below the article
![google-scholar](../lemons.png)

9. Select the box that says "Search within citing articles" and search for "Kenya"
(this is a great way to find papers -- if you know one paper that you like, you can find related papers that cite it).
10. Pick a paper that sounds interesting to you, and save it in the literature folder as well.
11. Stage and commit (with comments) the changes that you have made so far.
    > At the bottom of this file you can also see some nice shortcuts that will come in handy in the future.
12. Make a folder called Various/your_name folder using `mkdir` and add a file in it (either manually or using `mkdir`) called your_name_updates.md <br>
    > Remember, you are still on your branch in your local clone
    > You should be able to open an empty text editor window and then save the file with the .md file extension.
13. Type today's date and add a short summary of what you just did. Feel free to add any questions here too.
14. Stage these changes, too.
    > Remember, you can type `git status` to see what has changed.<br> 
    > Then type `git add [filename]` to _stage_ the changes.<br>
15. Commit your changes(with comments).
    > Remember, you commit using `git commit -m "[Helpful comments]"`<br>
16. Once you have committed your changes, you should _pull_ from the remote repo to make sure nobody has made other changes while you were working!<br>
    > This gives you git a chance to merge the other changes into your local clone, but your changes are safe since you have committed them.<br>
    > Do this with `git pull`
17. Finally, push the changes to the remote repo on GitHub using `git push origin [your-branch-name]`
18. Go to our repo on GitHub and look for your changes. Do you see them?
Look for a tab that says branches and switch to your branch. You should see them now.<br>
   > What do you see?

---

## Other stuff

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
