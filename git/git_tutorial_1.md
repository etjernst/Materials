## Git basics - what is this thing?

* The most popular version control system. Basically, if Dropbox and the "Track changes" feature in MS Word had a baby,
Git would be that baby.
* In fact, it's even better than that! Git is optimised for the things that economists and data scientists
spend a lot of time working on (e.g. code).
* There is a learning curve, but I _promise_ you it's worth it (and it will look great in grad school applications!)
* _Git_ and [_GitHub_](github.com) are not the same things: 
    * GitHub is an online hosting platform that provides an bunch of services built on top of the Git system.
    * You don't _need_ GitHub to use Git... But it will likely make your life much easier!
* The great thing about git is how much easier it makes transparency and reproducibility in research.

## Git vocab
* Project = repository / _repo_
* Folder location on your local computer = _working directory_
* _Stage:_  before you commit you tell git what you want to commit by staging it (an intermediate step)
* _Commit:_ git doesn’t make changes in its history (log) database unless we commit the files 
(think of this as a "yes, I am sure I want to commit these changes" step -- 
not that there are any dire consequences to committing, since you can always roll back to earlier versions)


## Basic workflow
In the below, replace the square brackets with the relevant info (without the square brackets)
1. **Make** changes to a file & save them in your local clone
2. **Stage** these local changes:<br>
  `git add [file]`
3. **Commit** these local changes to your Git history (with a helpful message!)<br>
  `git commit -m "[very helpful message]"`
4. **Pull** from the GitHub repo *just in case* anyone else made changes too:<br>
  `git pull`
  > I recommend always doing this even if you are working on your own!
5. **Push** your changes to the GitHub repo:<br>
  `git push`

**See next tutorial for how to modify this when working on a branch**

## Step 0 (a) - Setting up the first time you use git

Open up git bash, which should have come with the git installation. 

Set your name, which will be attached to your commits: <br>
  `git config --global user.name "[yournamehere]"`<br>
Set your email<br>
  `git config –-global user.email "[youremailhere]"`<br>

Check working directory (this will list where you are currently working)<br>
  `pwd` <br>
To change the directory, you can either type in the location where you want to work or drag the folder into the bash window. If your filepath has spaces in it, you need to start and end it with these little single commas: ' ' 
   
## Step 0 (b) - Clone the repo into a local directory on your computer
 
The main repo with code will live on GitHub, and then we work on a local clone, pulling and pushing our changes to GitHub.
We will not sync data to GitHub (only code). There are a few reasons for this:
  * the only "real" data is the raw data. As such, we should always be able to get from that raw data to the 
  analysis data using scripts (.do files in the case of Stata) -- so if you share data files with someone, 
  they should be able to take your scripts and reproduce your entire paper with the click of a button!
  * data files are binary so not very useful to version control
  * data files can be large, which will slow down syncing

So, we need to make a local clone! This is basically a local copy of everything on GitHub, with its own git version control 
keeping track of everything that you are doing.

1. Set the working directory to where you want to work from (again, you can either type the filepath or drag and drop the 
folder onto the git bash window)<br>
  `cd [filepath/drag file]`
  or<br>
  `cd [localfilepath]`
2. Tell git to clone everything that is on GitHub to a local directory 
(this will create a folder called [repo_name] wherever you pointed to in the above command)<br>
  `git clone [file_path_here]`
3. Now you want git bash to use that folder as your working directory, so tell it to do that<br>
  `cd [repo_name]`
<br>

**Note that you don't need to follow all these steps every time you work, only the first time** 
**-- that's why I called these steps Step 0.** Once you've done all this, you can just _pull_, work on your computer, 
save your work, _stage_ the changes, _commit_ those changes, and _push_ them.

## Step 0 (c) - Committing
To collaborate on a repository, we need to introduce two main things: _commits_ and _branches_<br>
I am starting with commits here.

You have probably used dropbox. How does it do version control? You can click on any file and see previous versions.<br>
![dropbox screenshot](https://github.com/etjernst/Materials/blob/master/dropbox.png "Dropbox screenshot")
From this you can tell that I click Ctrl+S A LOT! But are all these meaningful differences?<br>

Instead of having a list of each saved version of a file, in git you use commits to indicate what is each 
meaningful difference between two versions of our project folder.<br>
<br>
Each commit is a snap shot of all files in the project folder, and lists how that snapshot differs from 
the previous snapshot (i.e., the previous commit).<br>
<br>
Each commit has a time stamp and tracks who did the commit. This is similar to my old way of keeping track of things:
naming each version of a file _YYMMDD docname INITIALS.doc_... but much better!<br>
<br>
In order to have multiple people working in the same repository, you also need to know how to _branch_, 
but first let's practice doing a little commit.<br>

1. In your local clone, open up the README.md file in a text editor. It is in markdown format, but is easy to edit in any text editor.
[Here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) is a markdown cheat sheet 
if you want to try any more fancy things (and for future reference).<br>
2. Under collaborators, add your name to the file. `<br>` tells markdown that you want a new line. 
3. Save the file.
4. Using git bash, add a folder in the repo called Various using `mkdir Various`, which will create the folder in the working directory.
5. Manually add your CV to that folder (drag-and-drop or copy-paste the file).
6. Go back into git bash.
7. Check what changes have been made, by asking git the status of your local repository: `git status` 
_you should see the changes pop up_
8. _Stage_ the changes you just made in your local clone: `git add [file]` 
_where file is the files you saw listed as changed above -- for now just add each file separately; 
later we'll learn to do this with shortcuts_
9. _Commit_ these local changes to your git history (with a helpful message!): `git commit -m "[very helpful message]"` 
_this will tell git that you are serious about these changes and want to commit them to memory_
10. _Pull_ from the GitHub repo **just in case** anyone else made changes while you were working: `git pull` 
_this will check if anyone else has made changes to the original repo (and this is why we will soon learn about branches)_
11. _Push_ your changes to the GitHub repo: `git push`
12. Go to our repo on GitHub. Somewhere on the left near the top there's a link that says "# commits" (where # is a number)
13. Click on your recent commit. What do you see? 

Hopefully that all goes well! If not, please feel free to shoot me emails with questions. <br>
You can always include screenshots of what is going wrong, or refer me to a specific point in this doc where you got stuck! 
Hopefully, though, it will all run smoothly!

_Sources:_<br>
* Grant McDermott's great [lecture notes](https://github.com/uo-ec607/lectures)
* [Resources](https://github.com/worldbank/DIME-Resources) from the World Bank's DIME unit 
