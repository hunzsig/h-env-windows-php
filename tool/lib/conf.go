package lib

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

type SysData struct {
	IsAdmin     bool
	Ver         int
	Args        []string
	Pwd         string
	Log         string
	War3        string
	Temp        string
	Assets      string
	Projects    string
	ProjectName string
	Vendor      string
	Library     string
	W3x2lni     string
	WE          string
}

var (
	data SysData
)

func GetVar() SysData {
	if data.Pwd == "" {
		if IsFile("./conf") {
			c, err := os.ReadFile("./conf")
			if err != nil {
				fmt.Println("fail:", err.Error())
				os.Exit(-1)
			}
			content := string(c)
			reg, _ := regexp.Compile("#(.*)")
			content = reg.ReplaceAllString(content, "")
			content = strings.Replace(content, "\r\n", "\n", -1)
			content = strings.Replace(content, "\r", "\n", -1)
			split := strings.Split(content, "\n")
			conf := make(map[string]string)
			for _, iniItem := range split {
				if len(iniItem) > 0 {
					itemSplit := strings.Split(iniItem, "=")
					itemKey := strings.Trim(itemSplit[0], " ")
					itemKey = strings.ToLower(strings.Trim(itemSplit[0], " "))
					conf[itemKey] = strings.Trim(itemSplit[1], " ")
				}
			}
			if conf["root"] != "" {
				data.Pwd = conf["root"]
			}
		}
		if data.Pwd == "" {
			data.Pwd, _ = os.Getwd()
		}
		data.Pwd, _ = filepath.Abs(data.Pwd)
	}
	return data
}
