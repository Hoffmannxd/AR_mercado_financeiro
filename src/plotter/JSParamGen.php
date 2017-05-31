<?php 
// All to values below are hard coded to match the data provide from Google's document.
// You can always customize it to use the data from a databbase.
// If you use the data from a database, using a loop to create the values for cols and rows
// will be a good choice.
$col1=array();
$col1["id"]="";
$col1["label"]="Topping";
$col1["pattern"]="";
$col1["type"]="string";
//print_r($col1);
$col2=array();
$col2["id"]="";
$col2["label"]="Slices";
$col2["pattern"]="";
$col2["type"]="number";
//print_r($col2);
$cols = array($col1,$col2);
//print_r($cols);
 
$cell0["v"]="Mushrooms";
$cell0["f"]=null;
$cell1["v"]=3;
$cell1["f"]=null;
$row0["c"]=array($cell0,$cell1);
 
$cell0["v"]="Onion";
$cell1["v"]=1;
$row1["c"]=array($cell0,$cell1);
 
$cell0["v"]="Olives";
$cell1["v"]=1;
$row2["c"]=array($cell0,$cell1);
 
$cell0["v"]="Zucchini";
$cell1["v"]=1;
$row3["c"]=array($cell0,$cell1);
 
$cell0["v"]="Pepperoni";
$cell1["v"]=2;
$row4["c"]=array($cell0,$cell1);
 
//$rows=array($row0,$row1,$row2,$row3,$row4);
$rows=array();
array_push($rows,$row0);
array_push($rows,$row1);
array_push($rows,$row2);
array_push($rows,$row3);
array_push($rows,$row4);
 
 
//print_r($rows);
 
$data=array("cols"=>$cols,"rows"=>$rows);
//print_r($data);
echo json_encode($data);
