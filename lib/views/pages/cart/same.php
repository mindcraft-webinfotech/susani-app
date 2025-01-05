<?php include './common/session_db.php';
$periods = $conn->query("select * from periods order by id desc");
$period = $periods->fetch_assoc();
?>
<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Skystackin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.js"></script>
    <script>
        var source = new EventSource("../timerserver.php");
        var mystarttime = "";
        var count = 0;
        var time_gap = 3;
        var current_game_type_id = 1;
        source.onmessage = function(event) {

            var plus_time = time_gap * 60;
            mystarttime = event.data;
            mystarttime = plus_time - mystarttime;
            count++;
        };

        setInterval(function() {
            mystarttime--;
            test(mystarttime)
        }, 1000);

        function test(time) {

            var minutes = Math.floor(time / 60);
            var seconds = time - minutes * 60;
            if (minutes == 0 && seconds <= 30) {
                $(".disable_on_time").attr("disabled", "disabled");
            }

            if (minutes == 0 && seconds == 0) {
                window.location.href = "win.php";
            }


            if (minutes > 0) {
                $(".disable_on_time").removeAttr("disabled");

            }

            document.getElementById("result").innerHTML = minutes + ":" + seconds;

        }
    </script>

    <style>
        body {
            font-size: 13px;
        }

        .nav-pills .nav-link.active,
        .nav-pills .show>.nav-link {
            background-color: transparent;
            border-bottom: thin solid green;
            border-radius: 0px;
            color: black;
        }

        a {
            color: black;
        }

        a:hover {
            color: black;

        }

        .number-btn {
            width: 200px;
        }

        @media only screen and (max-width: 600px) {
            .number-btn {
                width: 50px;
            }

        }

        .footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            height: 50px;
            background-color: gray;
            box-shadow: 1px 1px 1px black;
            color: white;
            text-align: center;
        }

        #readRule * {
            font-size: 14px;
        }

        @media only screen and (min-width: 576px) {
            .joincolor .modal-dialog {
                max-width: 90% !important;
                margin: 3.75rem auto;
                /*background-color:grey;*/
                color: grey;
            }
        }

        .tablecenterCSS th,
        .tablecenterCSS td {
            font-size: 12px;
            text-align: center;
        }

        .dataTables_length {
            display: none !important;
        }

        table.dataTable thead th {
            border: none !important;
        }

        .timer_row {
            font-size: 15px;
        }

        #joining_header {
            color: black;
        }

        .bg-dark {
            background-color: #C9C9C9;
            padding: 5px;
            color: white;
        }

        .text-blur {
            color: #ABABAB;
            padding: 5px;
            color: black;
        }
    </style>
</head>

<body>
    <nav class="navbar navbar-expand-sm justify-content-center" style="background:#eee!important;">
        <strong>Skystackin</strong>
    </nav>
    <div class="container-fluid" style="padding-bottom: 50px;">
        <div class="row">
            <div class="col">
                <div class="container bg-primary">
                    <p style="padding: 20px;margin-bottom: 0px;font-size:12px;color:white; ">
                        In order to give back to new and old customers, starting today, the system will automatically give 1% rewards to members who recharge for the first time. The transaction flow reward has also been activated. The more transaction amount the more operations, the higher the reward will be, and it will be automatically returned to the account at 8 o'clock the next day. Lots of surprises and lots of rewards. Use your invitation code to start more people. ②In order to facilitate each user's withdrawal, our withdrawal time is 10:00-24:00. No withdrawal service will be provided at other times. ③Recently received feedback from many users. There are many criminals impersonating Rxce staff and official websites to defraud user account information and steal user account balances. Hereby remind users to strengthen their awareness of prevention. We will not use any account information that asks users in any form. Please do not disclose your account information to anyone. In this way, account security is guaranteed. I wish all users a happy life, thank you!
                    </p>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col">
                <div class="container bg-success">
                    <p style="padding: 20px; color:white;">
                        Available balance: ₹ <?php echo $user["wallet"]; ?>
                    </p>
                    <div class="" style="display: flex; justify-content:space-between; padding:10px; ">
                        <div>
                            <a href="recharge.php" class="btn btn-primary">Recharge</a>
                            <button class="btn btn-light" data-toggle="modal" data-target="#readRule">Read Rules</button>
                        </div>
                        <div style="color:white;"><i class="fas fa-circle"></i></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row timer_row">
            <div class="col mt-1">
                <div>

                    <ul class="nav nav-pills">
                        <li class="nav-item" style="width: 25%; text-align:center;" onclick="changeGameType(1);">
                            <a class="nav-link active" data-toggle="pill" href="#parity">Parity</a>
                        </li>
                        <li class="nav-item" style="width: 25%; text-align:center;" onclick="changeGameType(2);">
                            <a class="nav-link" data-toggle="pill" href="#sapre">Sapre</a>
                        </li>
                        <li class="nav-item" style="width: 25%; text-align:center;" onclick="changeGameType(3);">
                            <a class="nav-link" data-toggle="pill" href="#bcone">Bcone</a>
                        </li>
                        <li class="nav-item" style="width: 25%; text-align:center;" onclick="changeGameType(4);">
                            <a class="nav-link" data-toggle="pill" href="#emered">Emered</a>
                        </li>
                    </ul>
                    <div style="display: flex; justify-content:space-between; margin-top:30px; text-align:left;">
                        <span>Period</span>
                        <span>Count Down</span>
                    </div>
                    <div style="display: flex; justify-content:space-between; text-align:left;">
                        <span>
                            2022011
                            <span id="period"><?php echo $period["id"]; ?></span></span>
                        <span id="result">00:00</span>
                    </div>
                    <!-- Tab panes -->
                    <div class="tab-content">
                        <div class="tab-pane container-fluid active" id="parity">
                            <?php include "game_part1.php"; ?>
                        </div>
                        <div class="tab-pane container-fluid fade" id="sapre">
                            <?php include "game_part2.php"; ?>
                        </div>
                        <div class="tab-pane container-fluid fade" id="bcone">
                            <?php include "game_part3.php"; ?>
                        </div>
                        <div class="tab-pane container-fluid fade" id="emered">
                            <?php include "game_part4.php"; ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="footer" style="display: flex; justify-content: space-around; background-color:#eee!important;  box-shadow: 0px 0 5px -2px black;">
        <div>
            <a href="win.php"><span>Period</span></a>
        </div>
        <div>
            <a href="profiles.php"><span>Mine</span></a>
        </div>
    </div>

    <!-- ------------------------------- modals  -->
    <div class="modal fade" id="readRule" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content" style="width: 700px;">
                <div class="modal-header">

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <h4>Rule of Guess</h4>
                    <div class="col-md-12" style="margin-left: 10px;">
                        <p>3 minutes 1 issue, 2 minutes and 30 seconds to order, 30 seconds to show the lottery result. It opens all day. The total number of trade is 480 issues</p>
                        <p>If you spend 100 to trade, after deducting 2 service fee, your contract amount is 98:</p>
                    </div>
                    <ol>
                        <li><b>JOIN GREEN:</b> if the result shows 1,3,7,9, you will get (98*2) 196 <br>
                            If the result shows 5, you will get (98*1.5) 147</li>
                        <li><b>JOIN RED:</b> if the result shows 2,4,6,8, you will get (98*2) 196 <br>
                            If the result shows 0, you will get (98*1.5) 147</li>
                        <li><b>JOIN VIOLET:</b> if the result shows 0 or 5, you will get (98*4.5) 441</li>
                        <li><b>SELECT NUMBER:</b> if the result is the same as the number you selected, you will get (98*9) 882</li>
                    </ol>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

                </div>
            </div>
        </div>
    </div>

    <!--2 betting box----------------------->
    <div class="modal fade" id="bettingbox" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <!-- Modal content-->
            <div class="modal-content" style="width: 90%;">
                <div class="modal-header bg-green" style="color:white;" id="joining-modal-header">
                    <button type="button" class="close" data-dismiss="modal" style="color:white;">&times;</button>
                    <h4 class="modal-title" id="joining_header">Join Green</h4>
                    <!--Hidden values-->
                    <input type="hidden" name="attribute" value="Green" id="attribute">
                    <input type="hidden" value="10" id="contract" name="contract">
                    <input type="hidden" value="1" id="game_types_id" name="game_types_id">
                    <input type="hidden" value="<?php echo $period['id']; ?>" id="periods_id" name="periods_id">
                </div>
                <div class="modal-body">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-4">
                                <p>Contract Money</p>
                                <div style="box-shadow: 0px 0px 6px 0px #00000087;width: fit-content;padding: 7px 0px;">
                                    <span class="p-10-5 bg-dark contract" onclick="setContract(10);" id="contract10" style="cursor:pointer;">10</span>
                                    <span class="p-10-5 text-blur contract" onclick="setContract(100);" id="contract100" style="cursor:pointer;">100</span>
                                    <span class="p-10-5 text-blur contract" onclick="setContract(1000);" id="contract1000" style="cursor:pointer;">1000</span>
                                    <span class="p-10-5 text-blur contract" onclick="setContract(10000);" id="contract10000" style="cursor:pointer;">10000</span>

                                </div>
                            </div>
                        </div>
                        <div class="row mt-10">
                            <div class="col-md-8">
                                <p>Number</p>
                                <div class="mt-10">
                                    <span><i class="fa fa-plus" aria-hidden="true" style="width:30%;cursor: pointer;" onclick="addQuantity(+1)"></i></span>
                                    <span><input type="text" id="contract-quantity" value="1" style="border: none;width: 10%;" onchange="setContractMoney(this.value*contract.value)"></span>
                                    <span style="text-align: end;"><i class="fa fa-minus" aria-hidden="true" style="width:30%;cursor: pointer;" onclick="addQuantity(-1)"></i></span>
                                </div>
                                <p class="mt-10">Total Contract Money is <span id="contract-money">10</span></p>
                            </div>
                        </div>
                        <div class="row mt-10">
                            <div class="col-md-4">
                                <input type="checkbox" checked name="agreement" id="agreement" style="cursor:pointer;"><label for="agreement" style="cursor:pointer;">&nbsp; I agree <a target="_blank" href="#">&nbsp; PRESALE RULE</a></label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitJoining(agreement.value)">Confirm</button>
                </div>
            </div>

        </div>
    </div>
    <script>
        function showModal(modalid, header) {
            $('#' + modalid).modal('show');

            $("#bettingbox h4").text("Join " + header);
            $("#bettingbox").find("#attribute").val(header);
            $("#bettingbox").find("#game_types_id").val(current_game_type_id);

        }

        function bgDark(id) {

            $(".contract").removeClass("bg-dark");
            $("#contract" + id).removeClass("text-blur");
            $("#contract" + id).addClass("bg-dark");
        }

        function changeGameType(game_type_id) {
            current_game_type_id = game_type_id;
        }

        function addQuantity(quantity) {
            var contract_quantity = $("#bettingbox").find("#contract-quantity").val();
            final_contract_quantity = parseInt(contract_quantity) + parseInt(quantity);
            if (final_contract_quantity < 1) {
                alert("Quantity can't be less than 1");
                return;
            }

            $("#bettingbox").find("#contract-quantity").val(final_contract_quantity);
            var contract = $("#bettingbox").find("#contract").val();
            var contract_money = contract * final_contract_quantity;
            setContractMoney(contract_money);
        }

        function setContract(amount) {
            $("#bettingbox").find("#contract").val(amount);
            var sapn_id = "contract" + amount;
            // bgDark(sapn_id);
            var contract_quantity = $("#bettingbox").find("#contract-quantity").val();
            var final_amount = amount * contract_quantity;

            setContractMoney(final_amount);
        }

        function setContractMoney(amount) {

            $("#bettingbox").find("#contract-money").text(amount);
        }
        // joining--------------------------------
        function submitJoining(agreemrnt) {
            var period_id = "";
            var attribute = $("#bettingbox").find("#attribute").val();
            if (true) {
                var contract_money = $("#bettingbox").find("#contract-money").text();
                var wallet = <?php echo $user['wallet'] ?>;
                var remaining_wallet = wallet - contract_money;

                if (wallet < contract_money) {
                    alert("Insufficient fund");
                    return;
                }

                var game_types_id = $("#game_types_id").val();
                var period = $("#period").text();

                $.post("../controller/api1/common/update.php", {
                        wallet: remaining_wallet,
                        id: '<?php echo $user["id"]; ?>',
                        loginid: '<?php echo $user["id"]; ?>',
                        api_key: '<?php echo $user["api_key"]; ?>',
                        tbname: "user",
                    },

                    function(data, status) {
                        var data = JSON.parse(data);

                        if (data.status == "success") {

                            // This is for fetching periods_id
                            $.post("../controller/api1/common/selectPeriodId.php", {
                                    game_types_id: game_types_id,
                                    period: period,
                                    loginid: <?php echo $user["id"]; ?>,
                                    api_key: '<?php echo $user["api_key"]; ?>'
                                },

                                function(data, status) {

                                    var data = JSON.parse(data);
                                    period_id = data.id;

                                    if (attribute.length > 1 && period_id) {

                                        $.post("../controller/api1/common/insert2.php", {
                                                price: contract_money,
                                                color: attribute,
                                                periods_id: period_id,
                                                game_types_id: game_types_id,
                                                user_id: <?php echo $user["id"]; ?>,
                                                loginid: <?php echo $user["id"]; ?>,
                                                api_key: '<?php echo $user["api_key"]; ?>',
                                                tbname: "joinings"
                                            },

                                            function(data, status) {
                                                var data = JSON.parse(data);

                                                if (data.status == "success") {
                                                    alert("Joined Successfully");
                                                    location.reload();
                                                }
                                            });
                                    } else {
                                        $.post("../controller/api1/common/insert2.php", {
                                                price: contract_money,
                                                number: attribute,
                                                periods_id: period_id,
                                                game_types_id: game_types_id,
                                                user_id: <?php echo $user["id"]; ?>,
                                                loginid: <?php echo $user["id"]; ?>,
                                                api_key: '<?php echo $user["api_key"]; ?>',
                                                tbname: "joinings"
                                            },

                                            function(data, status) {
                                                var data = JSON.parse(data);

                                                if (data.status == "success") {
                                                    alert("Joined Successfully");
                                                    location.reload();
                                                }
                                            });
                                    }

                                });

                        }
                    });



            } else {
                alert("First Agree Terms");
                window.location.href("#agreement");
            }
        }
        // data table------------------------
        $(document).ready(function() {
            $('#Paritydatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
            $('#Sapredatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
            $('#Bconedatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
            $('#Emerddatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
            // ----------------------my datattable
            $('#MyParitydatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
            $('#MySapredatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
            $('#MyBconedatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
            $('#MyEmerddatatable').DataTable({
                "searching": false,
                "ordering": false,
                "info": false
            });
        });
    </script>
</body>

</html>