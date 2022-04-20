package main

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"tool/lib"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("You should set php version like this: php.ini.exe 5.6")
		os.Exit(-1)
	}
	sysData := lib.GetVar()
	version := "php_" + os.Args[1]
	extName, err := filepath.Abs(sysData.Pwd + "/" + version + "/" + version + "/ext")
	if err != nil {
		fmt.Println("You should set php version in range: (5.6 ~ 7.4)")
		os.Exit(-1)
	}

	fileName, err := filepath.Abs(sysData.Pwd + "/" + version + "/" + version + "/php.ini")
	if err != nil {
		fmt.Println("unknow error:", err)
		os.Exit(-1)
	}
	fmt.Println("ini file:", fileName)
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

	fmt.Println("php.ini is refresh!")
}
