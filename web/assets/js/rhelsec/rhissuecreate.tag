<issuecreate>
    <h3 class="text-primary">Create Issue</h3>

   <!--  <div class="row">
        <div class="pull-left">
            <form id="myform1" class="form-inline" onsubmit={ doSelectIssue } action="#">
                <div class="form-group">
                    <label for="idissue">Issue ID</label>
                    <select id="idissue" class="form-control">
                        <virtual each="{ value, i in issues }">
                            <option>{ value.issueid }</option>
                        </virtual>
                        <virtual if={ issues.length == 0 }>
                            <option value="" disabled selected>No Issue yet</option>
                        </virtual>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary" disabled={ issues.length == 0}>Edit</button>
            </form>
        </div>
        <div class="pull-right">
            <a class="btn btn-success" href={ doCreateIssue } role="button">Create</a>
        </div>
    </div> -->
    <hr>
    <div class="row">
    <div class="col-md-3 col-md-offset-4">
        <div if={ isLoading } class='loader center-block'>
            <!-- <img src='puff.svg' /> -->
            <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
        </div>

        <div class="alert alert-warning" if={ error }>{ error }</div>

        <form id="myform1" class="form" onsubmit={ doSubmit } action="#">
            <div class="form-group">
                <label for="idissueid">Issue ID:</label>
                <input id="idissueid" type="text" class="form-control" name="issueid" value={ issue.issueid } placeholder="The Issue ID to create">
            </div>
            <div class="center-block">
                <button type="button" class="btn btn-success" onclick={ doCreate }>Create</button>
                <button type="submit" class="btn btn-info" onclick={ doCancel }>Cancel</button>
            </div>
        </form>
        </div>
    </div>

    <script>

        this.issues = null;
        this.issue = null;
        this.isLoading = false;
        this.error = null;
        this.isdisabled = true;

        var self = this

        convert2Apilink(rhsa) {

            return '/gui/erratadetails/cvrf/' + rhsa;
        }

        goToEditableMode() {

            self.isdisabled = false;
            self.update();
            $('#idlocked').bootstrapToggle();
        }

        doSelectIssue() {

            var issue = $('#myform1').serialize();
            // self.update();
            self.doApiGetIssueData(issue);
        }

        doCreateIssue() {

            var issue = $('#myform1').serialize();
            // self.update();
            self.doApiGetIssueData(issue);
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

        doApiGetAllIssues() {

            var apiurl = "/api/issues";
            // if (criteria !== null && 0 !== criteria.length) {
            //     apiurl += "?" + criteria;
            // }

            self.isLoading = true;
            self.issues = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.issues = results.data;
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
                // $('#cvrftable').DataTable();
            });
        }

        doApiGetIssueData(issueid) {

            var apiurl = "/api/issues/" + issueid;
            // if (criteria !== null && 0 !== criteria.length) {
            //     apiurl += "?" + criteria;
            // }

            self.isLoading = true;
            self.issue = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.issue = results.data;
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
                // $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            // $('#iddatepicker').datepicker({
            //     autoclose: true,
            //     clearBtn: true,
            //     weekStart: 1,
            //     format: 'yyyy-mm-dd'
            // });
            // self.doApiGetAllIssues();
        })

    </script>

</issuecreate>
