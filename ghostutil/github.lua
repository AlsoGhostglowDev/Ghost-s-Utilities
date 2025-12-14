---@meta Github API
---@author T-Bar

---Functions that interact with the Github API
---@class Github

local git = {}

local web = require "ghostutil.web"
local util = require "ghostutil.util"

git.GITHUB_API_URL = "https://api.github.com/"

local function getAndParse(url, isArray)
    local data = util.parseJSON(web.getDataFromUrl(url));
	return data;
end

function git.getUser(user)
    return getAndParse(git.GITHUB_API_URL ..'users/'.. user)
end

function git.getRepository(user, repository)
    return getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository)
end

--TODO
function git.getBranches(user, repository)
    return getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository.. '/branches')
end

function git.getForks(user, repository)
    return getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository.. '/forks')
end

function git.getRepositoryIssues(user, repository)
    return getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository.. '/issues')
end

function git.getReleases(user, repository)
    return getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository.. '/releases')
end

function git.getContributors(user, repository)
	local retVal = getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository.. '/contributors')
    return (retVal or {});
end

function git.getOrganization(org)
    return getAndParse(git.GITHUB_API_URL ..'orgs/'.. org)
end

function git.getOrganizationMembers(org)
    local retVal = getAndParse(git.GITHUB_API_URL ..'orgs/'.. org ..'/members')
    return (retVal or {});
end

function git.filterReleases(releases, keepPrereleases, keepDrafts)
    local retVal = {}
    for i, release in ipairs(releases) do
        if release ~= nil and
            ((not release.prerelease) or (release.prerelease and keepPrereleases)) and
            ((not release.draft) or (release.draft and keepDrafts)) then
            table.insert(retVal, release)
        end
    end
    return retVal;
end

-- More in-depth Github tools

function git.getPullRequests(user, repository)
    local retVal = getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository)
    return retVal.topics;
end

function git.getRepositoryTags(user, repository)
    local retVal = git.getRepository();
    return (retVal or {});
end

function git.getRepositoryCommits()
	local retVal = getAndParse(git.GITHUB_API_URL ..'repos/'.. user ..'/'.. repository.. '/commits');
    return (retVal or {});
end

return git