<?php
require_once "../partials/header.php";

$userName = isset($_POST['inputUserName']) ? strip_tags($_POST['inputUserName']) : null;
$errors = isset($_GET['errors']) ? htmlentities($_GET['errors']) : null;
$errorList = '';
if ($errors) {
    $errorList .= "<div id='errorHolder' class='alert alert-danger'
    role='alert'>
    <div id='errorContent'>{$errors}</div></div>";
}

?>
 <!--Demo CSP Protection. -->
<!--<link href='http://www.momshomecookin.net/wp-content/themes/civilized-10/style.css' -->
<!--type='text/css' rel='stylesheet'>-->


<?php
require_once "../partials/indexFormPartial.php";
require_once "../partials/footer.php";
?>

<script type="text/javascript" src="js/index.js"></script>
</body>
</html>
