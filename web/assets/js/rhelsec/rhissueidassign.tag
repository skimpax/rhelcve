<issueidassign>
    <h3 class="text-primary">Issue ID Assignment</h3>

    <div>
        <h4>Search Criteria</h4>
        <form id="myform1" class="form-inline" onsubmit={ doSubmit } action="#">
            <div class="form-group">
                <label for="iddateafter">Since Date:</label>
                <div id="iddatepicker" class="input-group date" data-provide="datepicker">
                    <input id="dateafter" type="text" class="form-control" name="after">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </div>
                </div>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ items.length }>

            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Errata</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Errata</th>
                        <th>Action</th>
                    </tr>
                </tfoot>
                <tbody>
                    <tr each="{ value, i in items }">
                        <!-- <td>#{ i }</td> -->
                        <td>{ value.errata }</td>
                        <td>
                            <input id="idreboot" data-toggle="toggle" type="checkbox" data-on="Assign" data-off="Not Assigned" data-onstyle="success" data-offstyle="info" name="assign_{ value.errata }">
                            <a class="btn btn-primary" href={ doAssign(value.errata) } role="button">Assign It!</a>
                        </td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ items == null || items.length == 0 }>
            <div class="alert alert-info">No Issue ID found.</div>
        </div>
    </div>

    <script>

        this.items = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        convert2Apilink(rhsa) {

            return '/gui/erratadetails/cvrf/' + rhsa;
        }

        doAssign() {

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doApiRequest(queryparams);
        }

        doApiPostRequest(issueid, errata) {

            var apiurl = self.issueidapi;

            self.isLoading = true;
            self.update();

            $.post(apiurl, dataobj, function(results) {
                //console.log(results);
                alert("Assignment successfuly done!");
                //window.location.replace(self.triagepage);
                //location.reload(true);
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to send data to server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
            });
        }

        doApiRequest(issueid, errata) {

            var apiurl = "/api/issueids/" + issueid;
            // if (criteria !== null && 0 !== criteria.length) {
            //     apiurl += "?" + criteria;
            // }

            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.items = results.data;
                console.log(results.data);
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
                $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            $('#iddatepicker').datepicker({
                autoclose: true,
                clearBtn: true,
                weekStart: 1,
                format: 'yyyy-mm-dd'
            });
        })

    </script>

</issueidassign>
