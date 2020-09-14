---
title: "How to Contribute"
date: 2019-10-10T21:37:03-04:00
description: "See how you can contribute to the matplotblog."
categories: ["tutorials"]
displayInList: true
displayInMenu: true
draft: false
author: Davide Valeriani
resources:
- name: featuredImage
  src: "contribute.jpg"
  params:
    showOnTop: true
---

Matplotblog relies on your contributions to it. We want to showcase all the amazing projects that make use of Matplotlib. In this post, we will see which steps you have to follow to add a post to our blog.

To manage your contributions, we will use [Git pull requests](https://yangsu.github.io/pull-request-tutorial/). So, if you have not done it already, you first need to fork and clone [our Git repository](https://github.com/matplotlib/matplotblog), by clicking on the Fork button on the top right corner of the Github page, and then type the following in a terminal window:
```
git clone git@github.com:[USERNAME]/matplotblog.git
```
where [USERNAME] should be replaced by your Github username. You now have to make sure that if you reuse this forked repository, it is up to date with the main Matplotblog repository. To do so, type the following:
```
git remote add upstream https://github.com/matplotlib/matplotblog.git
```

You should now create a new branch, which will contain your changes. First, checkout the master:
```
git checkout master
git merge upstream/master
```

and then create a new branch and check it out:

```
cd matplotblog
git checkout -b post-my-fancy-title
```
The name of your branch should begin with *post-* followed by the short title of your blog post.

Then you should create a new blog post. We have used [Hugo](https://gohugo.io/) to create the Matplotblog, so you will first need to [install it](https://gohugo.io/getting-started/quick-start/#step-1-install-hugo). To create a new post, decide a title (e.g., *my-fancy-title*) and type the following:
```
hugo new posts/my-fancy-title/index.md
```

This command will create a new folder under *folder_repository/posts/* called *my-fancy-title*. This will be your working directory for the post. If you want to add external content to your post (e.g., images), you will add it to this folder.

You can now open the file *index.md* in your post folder with your favorite text editor. You will see a header section delimited by ---. Let us go through all the headings you can configure:
```
title: "Your fancy title"
```
This is the title of your post that will appear at the beginning of the page. Pick a catchy one.
```
date: 2019-09-01T21:37:03-04:00
```
The current date and time, you do not need to modify this.
```
draft: false
```
Specify that the post is not a draft and you want it to be published right away.
```
description: "This is my first post contribution."
```
This is a long description of the topic of your post. Modify it according to the content.
```
categories: ["tutorials"]
```
Pick the category you want your post to be added to. You can find the list of categories in the top right menu of matplotblog (except for Home and About).
```
displayInList: true
```
Specify that you want your post to appear in the list of latest posts and in the list of posts of the specified category.
```
author: Davide Valeriani
```
Add your name as author. Multiple authors are also possible, separate them by commas.
```
resources:
- name: featuredImage
  src: "my-image.jpg"
  params:
    description: "my image description"
    showOnTop: true
```
Select an image to be associated to your post, which will appear aside the title in the homepage. Make sure to add *my-image.jpg* to your post folder. The parameter *showOnTop* decides whether or not the image will also be shown at the top of your post.

Now, you can write the main text of your post. We fully support [markdown](https://markdown-guide.readthedocs.io/en/latest/basics.html), so use it to format your post.

To preview your new post, open a terminal and type:
```
hugo server
```
Then open the browser and visit [http://localhost:1313/matplotblog](http://localhost:1313/matplotblog) to make sure your post appears in the homepage. If you spot errors or something that you want to tune, go back to your index.md file and modify it.

When your post is ready to go, you can add it to your local repository, commit and push the changes to your branch:
```
git add content/posts/my-fancy-title
git commit -m "Added new blog post"
git push
```

Finally, submit a **pull request** to have our admins review your contribution and merge it to the master repository. To do so, type the following:
```
git checkout post-my-fancy-title
git rebase master
```
and then go to the page for your fork on GitHub, select your development branch, and click the pull request button. Your pull request will automatically track the changes on your development branch and update. Further info on the pull request process are available [here](https://docs.github.com/en/enterprise/2.16/user/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork).

That is it folks!
