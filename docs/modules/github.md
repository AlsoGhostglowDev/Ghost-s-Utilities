## `github.lua`
*A utility that interacts with the Github API.*

```lua
local git = require 'ghostutil.github'
```

---

### Fields

```lua
git.GITHUB_API_URL = "https://api.github.com/"
```
<sup>
The Github API link. This is the basis for all of the functions here.
</sup>

<br>

```lua
git.GITHUB_RAW_URL = {"https://raw.githubusercontent.com/", "refs/heads/main/"};
```
<sup>
The Github raw text link.
</sup>

<br>

---

### Methods
```lua
getUser(user: string): dictionary<string, dynamic>
```
Grabs a Github user's available info.

**Parameters:**
- `user`: The name of the user.
  
**Returns:** A dictionary containing the Github user data.

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getUser("TBar09")
debugPrint(foo.bio) 
-- Returns the bio for TBar09
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getRepository(user: string, repository: string): dictionary<string, dynamic>
```
Grabs a user's Github repository info.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.
  
**Returns:** A dictionary containing the Github repository data.

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getRepository("AlsoGhostglowDev", "Ghost-s-Utilities")
debugPrint(foo.description) 
-- Returns the description of the repository.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getBranches(user: string, repository: string): table<dynamic>
```
Grabs all of the branches of a Github repository.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.
  
**Returns:** A table with all branches of the repository.

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getBranches("AlsoGhostglowDev", "Ghost-s-Utilities")
debugPrint(foo[1].name) 
-- Returns the name of the first branch in the table
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getForks(user: string, repository: string): table<dynamic>
```
Grabs all of the forks of a Github repository.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.
  
**Returns:** A table with all forks of the repository.

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getForks("AlsoGhostglowDev", "Ghost-s-Utilities")
debugPrint(foo[1].fork) 
-- Returns if the first fork in the table is a fork, which would be true.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getRepositoryIssues(user: string, repository: string): table<dynamic>
```
Grabs all of the issue pages of a Github repository.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.
  
**Returns:** A table with all issue pages of the repository.

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getRepositoryIssues("CodenameCrew", "CodenameEngine")
debugPrint(foo[1].title) 
-- Returns the title of the first issue page for the repository.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getReleases(user: string, repository: string): table<dynamic>
```
Grabs all of the releases of a Github repository.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.
  
**Returns:** A table with all releases of the repository.

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getReleases("AlsoGhostglowDev", "Ghost-s-Utilities")
debugPrint(foo[1].body) 
-- Returns the release description of the first release page for the repository.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getContributors(user: string, repository: string): table<dynamic>
```
Grabs all the contributors of a Github repository.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.

**Returns:** A table with all contributors of the repository (A table of Github user data).

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getContributors("AlsoGhostglowDev", "Ghost-s-Utilities")
debugPrint(foo[1].login) 
-- Returns the name of the first contributor for the repository.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getOrganization(org: string): dictionary<string, dynamic>
```
Grabs a Github organization by name.

**Parameters:**
- `org`: The name of the organization.

**Returns:** A dictionary of the Github organization's data.

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getOrganization("FunkinCrew")
debugPrint(foo.followers) 
-- Returns the number of followers that the FunkinCrew organization has.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
getOrganizationMembers(org: string): table<dynamic>
```
Grabs a Github organization by name.

**Parameters:**
- `org`: The name of the organization.

**Returns:** A table with all members of the organization (A table of Github user data).

<details><summary>View Example</summary>
<p>

```lua
local foo = git.getOrganizationMembers("FunkinCrew")
for i, member in ipairs(foo) do
    debugPrint(member.login)
end
-- Prints out the name of every member in the FunkinCrew organization.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
git.filterReleases(releases: table<dynamic>, keepPrereleases: boolean, keepDrafts: boolean): table<dynamic>
```
Filters out a table of Github repository releases.

**Parameters:**
- `releases`: A table of all of the repository releases.
- `keepPrereleases`: Should prereleases not be filtered out?
- `keepDrafts`: Should release drafts not be filtered out?

**Returns:** A filtered table of Github releases (A table of Github repository releases).

<details><summary>View Example</summary>
<p>

```lua
local repoData = git.getReleases("ShadowMario", "FNF-PsychEngine")
local foo = git.filterReleases(repoData, false, false)
for i, release in ipairs(foo) do
    debugPrint(release.tag_name)
end
-- Prints the tag name of all releases that aren't prereleases or drafts.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
git.getPullRequests(user: string, repository: string): table<dynamic>
```
Grabs all the pull requests of a Github repository.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.

**Returns:** A table with all pull requests of the repository.

<details><summary>View Example</summary>
<p>

```lua
local repoData = git.getPullRequests("TBar09", "hxWindowColorMode-main")
debugPrint(repoData[1].title)
-- Prints the name of the first pull request in the table.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
git.getRepositoryTags(user: string, repository: string): table<dynamic>
```
Grabs all the tags of a Github repository. <br>
*<sup>(Not to be confused with `git.getRepositoryTopics`)</sup>*

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.

**Returns:** A table of all tags of the repository.

<details><summary>View Example</summary>
<p>

```lua
local repoData = git.getRepositoryTags("AlsoGhostglowDev", "Ghost-s-Utilities")
for i, tag in ipairs(repoData) do
    debugPrint(tag.name)
end
-- Prints the name of the every tag the repository has.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
git.getRepositoryTopics(user: string, repository: string): table<string>
```
Grabs all the topics in a Github repository. <br>
*<sup>(Not to be confused with `git.getRepositoryTags`)</sup>*

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.

**Returns:** A table of all topics the repository has.

<details><summary>View Example</summary>
<p>

```lua
local repoData = git.getRepositoryTopics("AlsoGhostglowDev", "Ghost-s-Utilities")
for i, tag in ipairs(repoData) do
    debugPrint(tag)
end
-- Prints all of the topics for the repository.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
git.getRepositoryCommits(user: string, repository: string): table<dynamic>
```
Grabs all the commits in a Github repository.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.

**Returns:** A table of all commits the repository has.

<details><summary>View Example</summary>
<p>

```lua
local repoData = git.getRepositoryCommits("AlsoGhostglowDev", "Ghost-s-Utilities")
for i, tag in ipairs(repoData) do
    debugPrint(tag.author.login)
end
-- Prints the author name for every commit in a repository.
```

</p>
</details>

<p align="center">─────────────────────────</p>

```lua
git.getRepositoryRawText(user: string, repository: string, filePath: string): string
```
Grabs data from a Github repository as a string.

**Parameters:**
- `user`: The name of the user with the repository.
- `repository`: The name of the repository.
- `filePath`: The path to the file, in the repository.

**Returns:** The file data.

<details><summary>View Example</summary>
<p>

```lua
local repoData = git.getRepositoryRawText("AlsoGhostglowDev", "Ghost-s-Utilities", "ghostutil/ghostutil.version")
debugPrint(repoData)
-- Prints the data from file "ghostutil/ghostutil.version".
```

</p>
</details>

<br>

---

<p align="center">
<sub><b>GhostUtil 3.0.0</b> • <b>Docs 3.0.0</b>, Revision 1</sub> <br><br>
<sub><i>
a Lua Library made by GhostglowDev; for <a href='https://github.com/ShadowMario/FNF-PsychEngine'>Psych Engine</a> <br>
© 2025 <a href='https://github.com/AlsoGhostglowDev'>GhostglowDev</a> — <a href='https://github.com/AlsoGhostglowDev/Ghost-s-Utilities'>Ghost's Utilities</a> <br>
Licensed under the <a href='https://opensource.org/license/mit'>MIT License</a>.
</sub></i>
</p>