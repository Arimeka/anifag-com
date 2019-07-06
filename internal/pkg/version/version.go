package version

import (
	"encoding/json"
	"fmt"
	"net/http"
)

// DefaultRoute default route
const DefaultRoute = "/build_info"

var (
	// Version application
	Version string
	// Service name
	Service string
	// BuildTime when binary was build
	BuildTime string
	// GitBranch current git branch
	GitBranch string
	// GitHash current git hash
	GitHash string
	// GitTreeState git is dirty?
	GitTreeState string
	// UserMail git-user email
	UserMail string
	// Hostname hostname of build server
	Hostname string
)

// BuildInfo store information about binary build
type BuildInfo struct {
	Version      string `json:"version"`
	Environment  string `json:"environment"`
	Service      string `json:"service"`
	BuildTime    string `json:"build_time"`
	GitBranch    string `json:"git_branch"`
	GitHash      string `json:"git_hash"`
	GitTreeState string `json:"git_tree_state"`
	UserMail     string `json:"git_user_email"`
	Hostname     string `json:"hostname"`
}

var currentBuild = new(BuildInfo)

func init() {
	currentBuild.Version = Version
	currentBuild.Service = Service
	currentBuild.Hostname = Hostname
	currentBuild.GitTreeState = GitTreeState
	currentBuild.UserMail = UserMail
	currentBuild.GitBranch = GitBranch
	currentBuild.BuildTime = BuildTime
	currentBuild.GitHash = GitHash
}

// Info get info about build
func Info() *BuildInfo {
	return currentBuild
}

// WithEnvironment add mode to build info
func (buildInfo *BuildInfo) WithEnvironment(environment string) *BuildInfo {
	buildInfo.Environment = environment
	return buildInfo
}

// JSON marshal build info to json string
func (buildInfo *BuildInfo) JSON() string {
	bytes, err := json.Marshal(&buildInfo)
	if err != nil {
		return fmt.Sprintf(`{"banner_error":"%s"}`, err.Error())
	}
	return string(bytes)
}

func (buildInfo *BuildInfo) ServeHTTP(response http.ResponseWriter, request *http.Request) {
	data, err := json.Marshal(&buildInfo)
	if err != nil {
		response.WriteHeader(http.StatusInternalServerError)
		return
	}
	response.Header().Set("Content-Type", "application/json; charset=utf-8")
	response.Write(data)
}
