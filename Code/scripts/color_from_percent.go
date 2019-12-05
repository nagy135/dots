package main

import "fmt"
import "strconv"

func main(){
    percent := 0
    max_red := "#c22330"
    max_red_r, _ := strconv.ParseInt(max_red[1:3], 16, 64)
    max_red_g, _ := strconv.ParseInt(max_red[3:5], 16, 64)
    max_red_b, _ := strconv.ParseInt(max_red[5:7], 16, 64)
    max_green := "#19a85b"
    max_green_r, _ := strconv.ParseInt(max_green[1:3], 16, 64)
    max_green_g, _ := strconv.ParseInt(max_green[3:5], 16, 64)
    max_green_b, _ := strconv.ParseInt(max_green[5:7], 16, 64)
    step_r := ( float64(max_green_r) - float64(max_red_r) ) / 100
    step_g := ( float64(max_green_g) - float64(max_red_g) ) / 100
    step_b := ( float64(max_green_b) - float64(max_red_b) ) / 100
    red := int(float64(max_red_r) + float64(percent) * step_r)
    green := int(float64(max_red_g) + float64(percent) * step_g)
    blue := int(float64(max_red_b) + float64(percent) * step_b)
    red_final := strconv.FormatInt(int64(red), 16)
    green_final := strconv.FormatInt(int64(green), 16)
    blue_final := strconv.FormatInt(int64(blue), 16)
    fmt.Println(red_final + green_final + blue_final)
}
