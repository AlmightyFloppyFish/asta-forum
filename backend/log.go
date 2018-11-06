package main

import "fmt"
import "github.com/fatih/color"

/*
	These can't take config reciever because not all methods have them,
	thereby isolating them from these funcs
*/

const (
	shouldShowInfo = true
)

func dinfo(args ...interface{}) {
	if shouldShowInfo {
		fmt.Println(color.MagentaString(" - Info: "), args)
	}
}

func dwarn(args ...interface{}) {
	fmt.Println(color.BlueString(" ? Warning: "), args)
}

func derr(args ...interface{}) {
	fmt.Println(color.RedString(" ! Error: "), args)
}

func clilog(args ...interface{}) {
	fmt.Println(color.HiYellowString(" : Exec: "), args)
}
