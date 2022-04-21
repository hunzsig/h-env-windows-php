package main

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"tool/lib"
)

func main() {
	sysData := lib.GetVar()
	versions := []string{
		"5.6",
		"7.0", "7.1", "7.2", "7.3", "7.4",
		"8.0", "8.1",
	}
	for _, v := range versions {
		n := "php_" + v
		extName, err := filepath.Abs(sysData.Vendor + "/" + n + "/ext")
		if err != nil {
			fmt.Println("fail:", v)
			os.Exit(-1)
		}

		fileName, err := filepath.Abs(sysData.Vendor + "/" + n + "/php.ini")
		if err != nil {
			fmt.Println("fail: ini", v)
			os.Exit(-1)
		}
		content, err1 := lib.FileGetContents(fileName)
		if err1 != nil {
			fmt.Println("fail:", err1.Error())
			os.Exit(-1)
		}
		reg, err2 := regexp.Compile(`extension_dir = ".*?"`)
		if err2 != nil {
			fmt.Println("fail:", err2.Error())
			os.Exit(-1)
		}
		newContent := reg.ReplaceAllString(content, "extension_dir = \""+extName+"\"")
		err3 := lib.FilePutContents(fileName, newContent, os.ModePerm)
		if err3 != nil {
			fmt.Println("fail:", err3.Error())
			os.Exit(-1)
		}
	}
	fmt.Println("php.ini is refresh!")
}
