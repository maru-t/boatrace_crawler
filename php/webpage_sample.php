<html>

<head>
<meta charset = "utf-8"/>
<title>Boatrace_crawrer</title>
</head>

<body>

<?php

        print "<p><a href=\"getquery.php\">query画面へ</a></p>";
	//設定ファイルの読み込み
	require_once("config.php");

        ini_set("mysqli.default_socket","/tmp/mysql.sock");

	//MySQLへの接続
	$link = mysqli_connect($dbserver,$user,$password,$dbname)
		or die("MySQL unconected");

	//文字コード設定
	mysqli_set_charset($link, "utf8")
		or die("can't link code");

	//問い合わせ
	$query = $_POST["query"];

	$result = mysqli_query($link,$query)
		or die("fail implements of query!");

	$rows = mysqli_num_rows($result);
	print "<p>該当件数は" . $rows . "件でした。<br />";

	print "<p>問い合わせ結果";
	print "<ul>";
	while ($row = $result->fetch_assoc()) {
		print "<li>";
		print_r($row);
		print "</li>";
	}
	print "</ul>";

	mysqli_free_result($result);

	mysqli_close($link);
?>
</body>
</html>

