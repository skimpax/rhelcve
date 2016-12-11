<rheltriage>
    <div>
        <h4>CVRF Search Criteria  <small>in Red Hat security DB</small></h4>
        <form id="myform1" class="form-inline" onsubmit={ doRhelGrab } action="#">
            <div class="form-group">
                <label for="iddateafter">Since Date:</label>
                <div id='iddatepicker' class="input-group date" data-provide="datepicker">
                    <input id="dateafter" type="text" class="form-control" name="after" required>
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="idseverity">Severity:</label>
                <select id="idseverity" class="form-control" name="severity" required>
                    <option value="critical">Critical</option>
                    <option value="important">Important</option>
                    <option value="moderate">Moderate</option>
                    <option value="low">Low</option>
                </select>
            </div>
            <div class="form-group">
                <label for="idrhelversion">RHEL Version:</label>
                <select id="idrhelversion" class="form-control" name="rhelversion" required>
                    <option value="v7">7.x</option>
                    <option value="v6" disabled>6.x</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center'>
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
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Title</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Title</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                        <th>Triage State</th>
                    </tr>
                </tfoot>
                <tbody>
                    <tr each="{ value, i in items }">
                        <!-- <td>#{ i }</td> -->
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
        <div if={ items == null || items.length == 0 }>
            <div class="alert alert-info">No CVRF emitted.</div>
        </div>
    </div>


    <script>

        this.erratadetailspage = null;
        this.triageapi = null;
        this.triageitpage = null;
        this.items = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        convert2Apilink(rhsa) {

            return self.erratadetailspage + rhsa;
        }

        convertTriageState(state) {
            return state;
        }

        goToTriageItPage(cvrf) {

            return self.triageitpage + cvrf;
        }

        doRhelGrab() {

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doApiRequest(queryparams);
        }

        doApiRequest(criteria = null) {

            var apiurl = self.triageapi;
            if (criteria !== null && 0 !== criteria.length) {
                apiurl += "?" + criteria;
            }
            console.log(apiurl);

            self.isLoading = true;
            self.error = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                console.log(results);
                self.items = results.data;
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

            var vpath = opts.erratadetailspage;
            self.erratadetailspage = vpath.replace('RHSA-0000:0000', '');

            vpath = opts.triageitpage;
            self.triageitpage = vpath.replace('RHSA-0000:0000', '');

            self.triageapi = opts.triageapi;

            $('#iddatepicker').datepicker({
                autoclose: true,
                clearBtn: true,
                weekStart: 1,
                format: 'yyyy-mm-dd'
            });
        })

    </script>

</rheltriage>
