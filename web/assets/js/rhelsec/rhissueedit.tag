<issueidassign>
    <h3 class="text-primary">Edit Issue ID</h3>

<!--     <div>
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
    </div> -->

    <form id="myform1" class="form" onsubmit={ doApply } action="#">
        <div class="form-group">
            <label for="idissue">Issue ID</label>
            <select id="idissue" class="form-control">
                <virtual each="{ value, i in issues }">
                    <option>{ value.issueid }</option>
                </virtual>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Edit</button>
    </form>
    <hr>

    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ issue }>
            <form id="myform1" class="form" onsubmit={ doSubmit } action="#">
                <div class="form-group">
                    <label for="idissueid">Issue ID:</label>
                    <input id="idissueid" type="text" class="form-control" name="issueid" value={ issue.issueid } placeholder="The Issue ID" disabled>
                </div>
                <div class="form-group">
                    <label for="idlocked">Locked:</label>
                    <input id="idlocked" data-toggle="toggle" type="checkbox" data-on="Locked" data-off="Unlocked" data-onstyle="danger" data-offstyle="success" name="locked" checked={ issue.locked } disabled={ isdisabled }>
                </div>

                <virtual if={ isdisabled }>
                    <button type="button" class="btn btn-primary center-block" onclick={ goToEditableMode }>Edit</button>
                </virtual>
                <virtual if={ !isdisabled }>
                    <button type="submit" class="btn btn-success center-block">Apply</button>
                </virtual>
            </form>
        </div>
        <div if={ issues == null || issues.length == 0 }>
            <div class="alert alert-info">No Issue ID found.</div>
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

        doApply() {

            self.curissueid = $('#myform1').serialize();
            self.update();
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

            var apiurl = "/api/issueids";
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

            var apiurl = "/api/issueids/" + issueid;
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
            self.doApiGetAllIssues();
        })

    </script>

</issueidassign>
