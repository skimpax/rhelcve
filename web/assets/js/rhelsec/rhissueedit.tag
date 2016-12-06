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
                <virtual each="{ value, i in issueids }">
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
        <div if={ curissueid }>
            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Issue ID</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>{ value.released_on }</td>
                        <td>{ value.RHSA }</td>
                        <td>{ value.title }</td>
                        <td>{ value.severity }</td>
                        <td>{ value.released_packages }</td>
                        <td><a href="{ convert2Apilink(value.RHSA) }">link</a></td>
                        <td>
                            <virtual if={ value.triage_decision == 'unknown' }>
                                <a class="btn btn-primary" href={ goToTriageItPage(value.RHSA) } role="button">Triage It!</a>
                            </virtual>
                            <virtual if={ value.triage_decision == 'accept' }>
                                <a class="btn btn-success" href={ goToTriageItPage(value.RHSA) } role="button">Accepted</a>
                            </virtual>
                            <virtual if={ value.triage_decision == 'reject' }>
                                <a class="btn btn-danger" href={ goToTriageItPage(value.RHSA) } role="button">Rejected</a>
                            </virtual>
                        </td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ issueids == null || issueids.length == 0 }>
            <div class="alert alert-info">No Issue ID found.</div>
        </div>
    </div>

    <script>

        this.issueids = [];
        this.issueid = null;
        this.isLoading = false;
        this.error = null;

        var self = this

        convert2Apilink(rhsa) {

            return '/gui/erratadetails/cvrf/' + rhsa;
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
            self.update();

            $.getJSON(apiurl, function(results) {
                self.issueids = results.data;
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
            self.issueid = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.issueid = results.data;
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
