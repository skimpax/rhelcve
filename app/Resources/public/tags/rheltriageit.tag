<rheltriageit>
  
    <hr>

    <div if={ isLoading } class='loader center'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ data != null }>
            <h3>Errata Data</h3>
            <div class="row">
                <div class="col-md-10 col-md-offset-1">
            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
<!--                 <thead>
                    <tr>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </tfoot> -->
                <tbody>
                    <tr>
                        <td><b>RHSA</b></td>
                        <td>{ data.RHSA }</td>
                    </tr>
                    <tr>
                        <td><b>Title</b></td>
                        <td>{ data.title }</td>
                    </tr>
                    <tr>
                        <td><b>Released Date </b></td>
                        <td>{ data.released_on }</td>
                    </tr>
                    <tr>
                        <td><b>Severity</b></td>
                        <td>{ data.severity }</td>
                    </tr>
                    <tr>
                        <td><b>Note</b></td>
                        <td>{ data.note }</td>
                    </tr>
                    <tr>
                        <td><b>Packages</b></td>
                        <td>{ data.released_packages }</td>
                    </tr>
                    <tr>
                        <td><b>RHEL Link</b></td>
                        <td><a href="{ data.rhel_weblink }">link</a></td>
                    </tr>
                </tbody>
            </table>
            </div>
            </div>
            <hr>
            <h3>Triage Decision</h3>
            <div class="row">
                <div class="col-md-6 col-md-offset-3">
                    <!-- place a notification if already have been triaged -->
                    <div class="alert alert-info" if={ data.triage_lastchange }>
                        <h5>Was triaged on: <b>{ displayDate(data.triage_lastchange) }</b> by <b>{ data.triage_user }</b></h5>
                    </div>

                    <form id="myform1" class="form" onsubmit={ doSubmit } action="#">
                        <div class="form-group">
                            <label for="iddecision">Decision:</label>
                            <select id="iddecision" class="form-control" name="decision" value={ data.triage_decision } disabled={ isdisabled } required>
                                <option class="bg-success" value="accept">Accept</option>
                                <option class="bg-danger" value="reject">Reject</option>
                                <option class="bg-info"value="unknown">Don't Know</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="idcomment">Comment:</label>
                            <textarea id="idcomment" class="form-control" name="comment" value={ data.triage_comment } placeholder="Some comment to explain the decision made" rows="3" disabled={ isdisabled }></textarea>
                        </div>
                        <div class="form-group">
                            <label for="iddomain">Domain:</label>
                            <input type="text" class="form-control" name="domain" value={ data.triage_domain } placeholder="Indicate domain this errata applies to" disabled={ isdisabled }>
                        </div>
                        <div class="form-group">
                            <label for="idpriority">Deploy Priority:</label>
                            <select id="idpriority" class="form-control" name="deployprio" value={ data.triage_deployprio } disabled={ isdisabled } required>
                                <option class="bg-primary" value="notapplicable">N/A</option>
                                <option class="bg-danger" value="high">High</option>
                                <option class="bg-warning" value="medium">Medium</option>
                                <option class="bg-info" value="low">Low</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="idreboot">Reboot Required:</label>
                            <input id="idreboot" data-toggle="toggle" type="checkbox" data-on="Yes" data-off="No" data-onstyle="danger" data-offstyle="info" name="rebootreq" checked={ data.triage_rebootreq } disabled={ isdisabled }>
                        </div>
                        <div class="form-group">
                            <input type="hidden" name="errata" value={ data.RHSA }>
                            <input type="hidden" name="erratadate" value={ data.released_on }>
                            <input type="hidden" name="user" value="clherieau">
                        </div>
                        <div class="text-center">
                            <div class="btn-group" role="group">
                                <virtual if={ isdisabled }>
                                    <button type="button" class="btn btn-success" onclick={ goToEditableMode }>Edit</button>
                                    <button type="button" class="btn btn-primary" onclick="history.back()">Cancel</button>
                                </virtual>
                                <virtual if={ !isdisabled }>
                                    <button type="submit" class="btn btn-success">Apply</button>
                                <button type="button" class="btn btn-primary" onclick="history.back()">Cancel</button>
                                </virtual>
                            </div>
                        </div>
                    </form>
                </div>
                <hr>
            </div>
        </div>
        <div if={ data == null || data.length == 0 }>
            <div class="alert alert-info">No data received.</div>
        </div>
    </div>


    <script>

        this.isdisabled = false;
        this.cvrf = null;
        this.triageitapi  = null;
        this.triagepage = null;
        this.data = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        displayDate(date) {
            //console.log(date);
            return date.date.substring(0, date.date.length - 7) + " " + date.timezone;
        }

        isEditable() {
            return true;
        }

        evalRebootReq(isReq) {
            // console.log(isReq);
            return isReq ? "on" : "off";
        }

        goToEditableMode() {

            self.isdisabled = false;
            self.update();
            $('#idreboot').bootstrapToggle();
        }

        doSubmit() {

            console.log($('#myform1').serialize());

            var obj = self.getFormData('#myform1');
            self.doApiPostRequest(self.cvrf, obj);
        }

        getFormData(form) {

            var unindexed_array = $(form).serializeArray();
            var indexed_array = {};

            $.map(unindexed_array, function(n, i){
                indexed_array[n['name']] = n['value'];
            });

            return indexed_array;
        }

        doApiGetRequest(cvrf) {

            var apiurl = self.triageitapi; //"/api/rheltriage/" + cvrf;

            self.isLoading = true;
            self.error = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                // console.log(results.data);
                self.data = results.data;
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
                self.isdisabled = self.data.triage_lastchange !== undefined;
                self.update();
                $('#idreboot').bootstrapToggle();
            });
        }

        doApiPostRequest(cvrf, dataobj) {

            var apiurl = self.triageitapi;

            self.isLoading = true;
            self.error = null;
            self.update();

            $.post(apiurl, dataobj, function(results) {
                //console.log(results);
                alert("Triage successfuly done!");
                //window.location.replace(self.triagepage);
                location.reload(true);
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

        self.on('mount', function() {

            self.cvrf = opts.cvrf;
            self.triageitapi = opts.triageitapi;
            self.triagepage = opts.triagepage;

            //$('#idreboot').bootstrapToggle();

            self.doApiGetRequest(self.cvrf);
        })

    </script>

</rheltriageit>
